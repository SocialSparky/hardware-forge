// ============================================================================
// HARDWARE FORGE — UNIVERSAL 2D INTERACTIVE SCHEMATIC & DESIGNER SUITE
// Supports: Boxes (06), Fasteners (01), Standoffs (04), Clamps (07),
//           Brackets (08), Knobs (09), Enclosures (10), Gauges (11), Gaskets (12)
// ============================================================================

let boxLayoutState = {
  innerW: 95.2,
  innerD: 65.2,
  divT: 1.6,
  colWidths: [30, 30, 32],
  colRows: [[31.8, 31.8], [31.8, 31.8], [31.8, 31.8]],
  selectedCol: 0,
  dragging: null,
  lastColsParam: -1,
  lastRowsParam: -1
};

function ensureDesignerCard() {
  let card = document.getElementById("box-designer-card");
  if (!card) {
    const paramsCont = document.getElementById("params-container");
    if (paramsCont && paramsCont.parentNode) {
      card = document.createElement("div");
      card.id = "box-designer-card";
      card.style.cssText = "margin:10px 18px 4px 18px; padding:10px 12px; background:rgba(15, 23, 42, 0.88); border:1px solid #3b82f6; border-radius:6px; font-size:0.75rem; color:#dbeafe; display:none; box-shadow:0 4px 12px rgba(0,0,0,0.35);";
      paramsCont.parentNode.insertBefore(card, paramsCont);
    }
  }
  return card;
}

function setParamFromVisual(paramName, val) {
  const el = document.querySelector(`[data-param="${paramName}"]`);
  if (!el) return;
  if (el.tagName === "SELECT") {
    const matchOpt = Array.from(el.options).find(o => String(o.value) === String(val));
    if (matchOpt) {
      el.value = String(val);
      const custWrap = document.getElementById(`custom-wrap-${paramName}`);
      if (custWrap) custWrap.style.display = "none";
    } else {
      const custOpt = Array.from(el.options).find(o => o.value === "__custom__");
      if (custOpt) {
        el.value = "__custom__";
        const custWrap = document.getElementById(`custom-wrap-${paramName}`);
        if (custWrap) custWrap.style.display = "flex";
        const custInp = document.querySelector(`[data-custom-for="${paramName}"]`);
        if (custInp) {
          custInp.value = String(val);
          const unitSel = document.querySelector(`[data-unit-for="${paramName}"]`);
          if (unitSel) unitSel.value = "mm";
        }
      }
    }
  } else {
    el.value = String(val);
  }
  if (typeof updateVisibility === "function") updateVisibility();
  updateMaster2DDesigner(false);
  const autoChk = document.getElementById("auto-render");
  if (autoChk && autoChk.checked && typeof renderPart === "function") {
    clearTimeout(window.renderTimeout);
    window.renderTimeout = setTimeout(() => renderPart(), 200);
  }
}

function updateMaster2DDesigner(forceReset = false) {
  const card = ensureDesignerCard();
  if (!card || typeof currentGenerator === "undefined" || !currentGenerator) return;

  const fname = currentGenerator.filename;
  const vals = (typeof collectParams === "function") ? collectParams() : {};

  if (fname === "06_boxes_organizers.scad") {
    initOrSyncBoxDesigner(forceReset);
  } else if (fname === "01_fasteners.scad") {
    renderFastener2D(card, vals);
  } else if (fname === "04_spacers_standoffs.scad") {
    renderSpacer2D(card, vals);
  } else if (fname === "07_clamps_mounts.scad") {
    renderClamp2D(card, vals);
  } else if (fname === "08_brackets_joinery.scad") {
    renderBracket2D(card, vals);
  } else if (fname === "09_knobs_handles.scad") {
    renderKnob2D(card, vals);
  } else if (fname === "10_enclosures_plates.scad") {
    renderEnclosure2D(card, vals);
  } else if (fname === "11_gauges_jigs.scad") {
    renderGauge2D(card, vals);
  } else if (fname === "12_gaskets_seals.scad") {
    renderGasket2D(card, vals);
  } else {
    card.style.display = "none";
  }
}

// ============================================================================
// 1. BOXES & ORGANIZERS 2D DRAG-AND-SLIDE CUBBY DESIGNER (06)
// ============================================================================
function initOrSyncBoxDesigner(forceReset = false) {
  const card = ensureDesignerCard();
  if (!card) return;
  const vals = collectParams();
  if (vals.box_style === "gift_box") {
    card.style.display = "none";
    return;
  }
  card.style.display = "block";

  const rawLayoutWrap = document.getElementById("wrap-layout_spec");
  const rawSlotWrap = document.getElementById("wrap-drawer_slot_spec");
  if (rawLayoutWrap) rawLayoutWrap.style.display = "none";
  if (rawSlotWrap) rawSlotWrap.style.display = "none";

  const W = parseFloat(vals.outer_width) || 100;
  const D = parseFloat(vals.outer_depth) || 70;
  const T = parseFloat(vals.wall_thick) || 2.4;
  const divT = parseFloat(vals.divider_thick) || 1.6;
  const targetCols = Math.max(1, Math.round(parseFloat(vals.cols) || 3));
  const defaultRows = Math.max(1, Math.round(parseFloat(vals.rows) || 2));

  boxLayoutState.innerW = Math.max(10, W - 2 * T);
  boxLayoutState.innerD = Math.max(10, D - 2 * T);
  boxLayoutState.divT = divT;

  const colsChanged = (targetCols !== boxLayoutState.lastColsParam);
  const rowsChanged = (defaultRows !== boxLayoutState.lastRowsParam);

  if (forceReset || boxLayoutState.colWidths.length !== targetCols || colsChanged || rowsChanged) {
    boxLayoutState.lastColsParam = targetCols;
    boxLayoutState.lastRowsParam = defaultRows;
    const availW = Math.max(targetCols * 4, boxLayoutState.innerW - (targetCols - 1) * divT);
    const eqW = +(availW / targetCols).toFixed(1);
    boxLayoutState.colWidths = Array(targetCols).fill(eqW);
    boxLayoutState.colRows = [];
    for (let c = 0; c < targetCols; c++) {
      const availD = Math.max(defaultRows * 4, boxLayoutState.innerD - (defaultRows - 1) * divT);
      const eqD = +(availD / defaultRows).toFixed(1);
      boxLayoutState.colRows.push(Array(defaultRows).fill(eqD));
    }
    if (boxLayoutState.selectedCol >= targetCols) boxLayoutState.selectedCol = 0;
  }

  rebalanceBoxRemainders();
  renderBoxDesignerUI();
  syncLayoutSpecToInput(false);
}

function rebalanceBoxRemainders() {
  const cNum = boxLayoutState.colWidths.length;
  const divT = boxLayoutState.divT;
  const availW = Math.max(cNum * 4, boxLayoutState.innerW - (cNum - 1) * divT);
  const minCell = 4.0;

  if (cNum === 1) {
    boxLayoutState.colWidths[0] = +availW.toFixed(1);
  } else {
    let sumFirst = 0;
    for (let i = 0; i < cNum - 1; i++) {
      boxLayoutState.colWidths[i] = Math.max(minCell, +boxLayoutState.colWidths[i] || minCell);
      sumFirst += boxLayoutState.colWidths[i];
    }
    const maxFirst = availW - minCell;
    if (sumFirst > maxFirst && sumFirst > 0) {
      const scale = maxFirst / sumFirst;
      sumFirst = 0;
      for (let i = 0; i < cNum - 1; i++) {
        boxLayoutState.colWidths[i] = +(boxLayoutState.colWidths[i] * scale).toFixed(1);
        sumFirst += boxLayoutState.colWidths[i];
      }
    }
    boxLayoutState.colWidths[cNum - 1] = +(availW - sumFirst).toFixed(1);
  }

  for (let c = 0; c < cNum; c++) {
    const rList = boxLayoutState.colRows[c];
    const rNum = rList.length;
    const availD = Math.max(rNum * 4, boxLayoutState.innerD - (rNum - 1) * divT);
    if (rNum === 1) {
      rList[0] = +availD.toFixed(1);
    } else {
      let sumR = 0;
      for (let r = 0; r < rNum - 1; r++) {
        rList[r] = Math.max(minCell, +rList[r] || minCell);
        sumR += rList[r];
      }
      const maxR = availD - minCell;
      if (sumR > maxR && sumR > 0) {
        const scale = maxR / sumR;
        sumR = 0;
        for (let r = 0; r < rNum - 1; r++) {
          rList[r] = +(rList[r] * scale).toFixed(1);
          sumR += rList[r];
        }
      }
      rList[rNum - 1] = +(availD - sumR).toFixed(1);
    }
  }
}

function syncLayoutSpecToInput(triggerRender = true) {
  const inp = document.querySelector('[data-param="layout_spec"]');
  if (!inp) return;
  const parts = [];
  for (let c = 0; c < boxLayoutState.colWidths.length; c++) {
    const w = boxLayoutState.colWidths[c].toFixed(1);
    const rStr = boxLayoutState.colRows[c].map(v => v.toFixed(1)).join(",");
    parts.push(`${w}:${rStr}`);
  }
  inp.value = parts.join("|");
  if (triggerRender && document.getElementById("auto-render") && document.getElementById("auto-render").checked) {
    clearTimeout(window.renderTimeout);
    window.renderTimeout = setTimeout(() => renderPart(), 180);
  }
}

function setColWidthFromSlider(colIdx, newVal) {
  const cNum = boxLayoutState.colWidths.length;
  if (colIdx >= cNum - 1) return;
  const availW = Math.max(cNum * 4, boxLayoutState.innerW - (cNum - 1) * boxLayoutState.divT);
  let otherSum = 0;
  for (let i = 0; i < cNum - 1; i++) if (i !== colIdx) otherSum += boxLayoutState.colWidths[i];
  const maxAllowed = Math.max(4.0, availW - otherSum - 4.0);
  boxLayoutState.colWidths[colIdx] = Math.min(maxAllowed, Math.max(4.0, parseFloat(newVal) || 4.0));
  rebalanceBoxRemainders();
  renderBoxDesignerUI();
  syncLayoutSpecToInput(true);
}

function setRowDepthFromSlider(colIdx, rowIdx, newVal) {
  const rList = boxLayoutState.colRows[colIdx];
  const rNum = rList.length;
  if (rowIdx >= rNum - 1) return;
  const availD = Math.max(rNum * 4, boxLayoutState.innerD - (rNum - 1) * boxLayoutState.divT);
  let otherSum = 0;
  for (let i = 0; i < rNum - 1; i++) if (i !== rowIdx) otherSum += rList[i];
  const maxAllowed = Math.max(4.0, availD - otherSum - 4.0);
  rList[rowIdx] = Math.min(maxAllowed, Math.max(4.0, parseFloat(newVal) || 4.0));
  rebalanceBoxRemainders();
  renderBoxDesignerUI();
  syncLayoutSpecToInput(true);
}

function changeColRowCount(colIdx, delta) {
  const rList = boxLayoutState.colRows[colIdx];
  const newCount = Math.min(8, Math.max(1, rList.length + delta));
  const availD = Math.max(newCount * 4, boxLayoutState.innerD - (newCount - 1) * boxLayoutState.divT);
  const eqD = +(availD / newCount).toFixed(1);
  boxLayoutState.colRows[colIdx] = Array(newCount).fill(eqD);
  rebalanceBoxRemainders();
  renderBoxDesignerUI();
  syncLayoutSpecToInput(true);
}

function changeTotalColsCount(delta) {
  const vals = collectParams();
  const cur = Math.max(1, Math.round(parseFloat(vals.cols) || 3));
  const next = Math.min(8, Math.max(1, cur + delta));
  setParamFromVisual("cols", next);
}

function resetAllCubbiesEqual() {
  initOrSyncBoxDesigner(true);
  syncLayoutSpecToInput(true);
}

function renderBoxDesignerUI() {
  const card = ensureDesignerCard();
  if (!card) return;

  const cNum = boxLayoutState.colWidths.length;
  const selCol = Math.min(cNum - 1, boxLayoutState.selectedCol);
  const availW = Math.max(cNum * 4, boxLayoutState.innerW - (cNum - 1) * boxLayoutState.divT);
  const rList = boxLayoutState.colRows[selCol];
  const rNum = rList.length;
  const availD = Math.max(rNum * 4, boxLayoutState.innerD - (rNum - 1) * boxLayoutState.divT);

  let colSlidersHTML = "";
  for (let c = 0; c < cNum; c++) {
    const isLast = (c === cNum - 1);
    const val = boxLayoutState.colWidths[c].toFixed(1);
    colSlidersHTML += `
      <div style="display:flex; align-items:center; gap:6px; margin-bottom:4px; font-size:0.73rem;">
        <span style="width:48px; color:${c === selCol ? '#60a5fa' : '#9ca3af'}; font-weight:${c === selCol ? '700' : '500'}; cursor:pointer;" onclick="boxLayoutState.selectedCol=${c}; renderBoxDesignerUI();">Col ${c+1}:</span>
        ${isLast ? `
          <div style="flex:1; background:#121418; padding:2px 8px; border-radius:4px; border:1px dashed #3b82f6; color:#93c5fd;">
            Auto Remainder: <strong>${val} mm</strong>
          </div>
        ` : `
          <input type="range" min="4" max="${(availW - 4).toFixed(1)}" step="0.5" value="${val}" style="flex:1; accent-color:#3b82f6;"
            oninput="setColWidthFromSlider(${c}, this.value)">
          <input type="number" step="0.5" value="${val}" style="width:54px; padding:2px 4px; font-size:0.73rem; text-align:right;"
            onchange="setColWidthFromSlider(${c}, this.value)">
        `}
      </div>`;
  }

  let rowSlidersHTML = "";
  for (let r = 0; r < rNum; r++) {
    const isLast = (r === rNum - 1);
    const val = rList[r].toFixed(1);
    rowSlidersHTML += `
      <div style="display:flex; align-items:center; gap:6px; margin-bottom:4px; font-size:0.73rem;">
        <span style="width:48px; color:#cbd5e1;">Row ${r+1}:</span>
        ${isLast ? `
          <div style="flex:1; background:#121418; padding:2px 8px; border-radius:4px; border:1px dashed #10b981; color:#6ee7b7;">
            Auto Remainder: <strong>${val} mm</strong>
          </div>
        ` : `
          <input type="range" min="4" max="${(availD - 4).toFixed(1)}" step="0.5" value="${val}" style="flex:1; accent-color:#10b981;"
            oninput="setRowDepthFromSlider(${selCol}, ${r}, this.value)">
          <input type="number" step="0.5" value="${val}" style="width:54px; padding:2px 4px; font-size:0.73rem; text-align:right;"
            onchange="setRowDepthFromSlider(${selCol}, ${r}, this.value)">
        `}
      </div>`;
  }

  let colTabs = "";
  for (let c = 0; c < cNum; c++) {
    const active = (c === selCol);
    colTabs += `<button onclick="boxLayoutState.selectedCol=${c}; renderBoxDesignerUI();"
      style="flex:1; padding:3px 5px; font-size:0.71rem; border-radius:4px; background:${active ? '#2563eb' : '#1f2937'}; color:${active ? '#fff' : '#9ca3af'}; border:1px solid ${active ? '#60a5fa' : '#374151'};">
      Col ${c+1} (${boxLayoutState.colRows[c].length}R)
    </button>`;
  }

  card.innerHTML = `
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">
      <strong style="color:#60a5fa;">📐 2D Cubby & Divider Designer (Anti-Mix Lid Synced!)</strong>
      <button onclick="resetAllCubbiesEqual()" style="width:auto; padding:2px 8px; font-size:0.68rem; background:#374151; color:#e5e7eb;">Reset Equal</button>
    </div>
    <canvas id="cubby-canvas" width="376" height="165" style="width:100%; height:165px; background:#0f172a; border:1px solid #3b82f6; border-radius:6px; cursor:move; display:block; margin-bottom:8px;"></canvas>
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:4px;">
      <span style="font-size:0.72rem; color:#93c5fd; font-weight:700;">↔️ Columns (Usable X: ${availW.toFixed(1)} mm)</span>
      <div style="display:flex; align-items:center; gap:4px;">
        <span style="font-size:0.69rem; color:#9ca3af;">Cols:</span>
        <button onclick="changeTotalColsCount(-1)" style="width:22px; padding:1px 0; font-size:0.74rem; background:#1f2937;">-</button>
        <strong style="font-size:0.74rem; width:14px; text-align:center;">${cNum}</strong>
        <button onclick="changeTotalColsCount(1)" style="width:22px; padding:1px 0; font-size:0.74rem; background:#1f2937;">+</button>
      </div>
    </div>
    ${colSlidersHTML}
    <div style="margin-top:7px; padding-top:6px; border-top:1px solid rgba(59,130,246,0.3);">
      <div style="display:flex; gap:4px; margin-bottom:6px;">${colTabs}</div>
      <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:4px;">
        <span style="font-size:0.72rem; color:#6ee7b7; font-weight:700;">↕️ Col ${selCol+1} Rows (Usable Y: ${availD.toFixed(1)} mm)</span>
        <div style="display:flex; align-items:center; gap:4px;">
          <span style="font-size:0.69rem; color:#9ca3af;">Rows in Col ${selCol+1}:</span>
          <button onclick="changeColRowCount(${selCol}, -1)" style="width:22px; padding:1px 0; font-size:0.74rem; background:#1f2937;">-</button>
          <strong style="font-size:0.74rem; width:14px; text-align:center;">${rNum}</strong>
          <button onclick="changeColRowCount(${selCol}, 1)" style="width:22px; padding:1px 0; font-size:0.74rem; background:#1f2937;">+</button>
        </div>
      </div>
      ${rowSlidersHTML}
    </div>
  `;

  drawCubbyCanvas();
  bindCanvasDragEvents();
}

function drawCubbyCanvas() {
  const cvs = document.getElementById("cubby-canvas");
  if (!cvs) return;
  const ctx = cvs.getContext("2d");
  const W = cvs.width, H = cvs.height;
  ctx.clearRect(0, 0, W, H);
  const pad = 10, drawW = W - pad * 2, drawH = H - pad * 2;
  const totalX = boxLayoutState.colWidths.reduce((a, b) => a + b, 0);
  let curX = pad;

  for (let c = 0; c < boxLayoutState.colWidths.length; c++) {
    const cw = boxLayoutState.colWidths[c];
    const pixW = (cw / totalX) * drawW;
    const rList = boxLayoutState.colRows[c];
    const totalY = rList.reduce((a, b) => a + b, 0);
    let curY = pad;

    for (let r = 0; r < rList.length; r++) {
      const rd = rList[r];
      const pixH = (rd / totalY) * drawH;
      ctx.fillStyle = (c === boxLayoutState.selectedCol) ? "rgba(37, 99, 235, 0.28)" : "rgba(30, 41, 59, 0.85)";
      ctx.fillRect(curX + 1, curY + 1, pixW - 2, pixH - 2);
      ctx.strokeStyle = (c === boxLayoutState.selectedCol) ? "#60a5fa" : "#475569";
      ctx.lineWidth = 1.5;
      ctx.strokeRect(curX + 1, curY + 1, pixW - 2, pixH - 2);

      ctx.fillStyle = "#e2e8f0";
      ctx.font = "600 10px system-ui, sans-serif";
      ctx.textAlign = "center";
      ctx.textBaseline = "middle";
      if (pixW > 30 && pixH > 15) {
        ctx.fillText(`${cw.toFixed(0)}×${rd.toFixed(0)}`, curX + pixW / 2, curY + pixH / 2);
      }
      if (r < rList.length - 1) {
        ctx.strokeStyle = "#10b981";
        ctx.lineWidth = 2.5;
        ctx.beginPath();
        ctx.moveTo(curX + 3, curY + pixH);
        ctx.lineTo(curX + pixW - 3, curY + pixH);
        ctx.stroke();
      }
      curY += pixH;
    }
    if (c < boxLayoutState.colWidths.length - 1) {
      ctx.strokeStyle = "#f59e0b";
      ctx.lineWidth = 3;
      ctx.beginPath();
      ctx.moveTo(curX + pixW, pad);
      ctx.lineTo(curX + pixW, pad + drawH);
      ctx.stroke();
    }
    curX += pixW;
  }
}

function bindCanvasDragEvents() {
  const cvs = document.getElementById("cubby-canvas");
  if (!cvs) return;
  const pad = 10;
  cvs.onmousedown = (e) => {
    const rect = cvs.getBoundingClientRect();
    const mx = (e.clientX - rect.left) * (cvs.width / rect.width);
    const my = (e.clientY - rect.top) * (cvs.height / rect.height);
    const drawW = cvs.width - pad * 2, drawH = cvs.height - pad * 2;
    const totalX = boxLayoutState.colWidths.reduce((a, b) => a + b, 0);
    let curX = pad;
    for (let c = 0; c < boxLayoutState.colWidths.length - 1; c++) {
      curX += (boxLayoutState.colWidths[c] / totalX) * drawW;
      if (Math.abs(mx - curX) <= 7) {
        boxLayoutState.dragging = { type: "col", idx: c, startX: mx, startW: boxLayoutState.colWidths[c] };
        return;
      }
    }
    curX = pad;
    for (let c = 0; c < boxLayoutState.colWidths.length; c++) {
      const pixW = (boxLayoutState.colWidths[c] / totalX) * drawW;
      if (mx >= curX && mx <= curX + pixW) {
        boxLayoutState.selectedCol = c;
        const rList = boxLayoutState.colRows[c];
        const totalY = rList.reduce((a, b) => a + b, 0);
        let curY = pad;
        for (let r = 0; r < rList.length - 1; r++) {
          curY += (rList[r] / totalY) * drawH;
          if (Math.abs(my - curY) <= 7) {
            boxLayoutState.dragging = { type: "row", colIdx: c, idx: r, startY: my, startD: rList[r] };
            return;
          }
        }
        renderBoxDesignerUI();
        return;
      }
      curX += pixW;
    }
  };
  window.onmousemove = (e) => {
    if (!boxLayoutState.dragging) return;
    const cvsEl = document.getElementById("cubby-canvas");
    if (!cvsEl) return;
    const rect = cvsEl.getBoundingClientRect();
    const mx = (e.clientX - rect.left) * (cvsEl.width / rect.width);
    const my = (e.clientY - rect.top) * (cvsEl.height / rect.height);
    const drawW = cvsEl.width - pad * 2, drawH = cvsEl.height - pad * 2;
    if (boxLayoutState.dragging.type === "col") {
      const totalX = boxLayoutState.colWidths.reduce((a, b) => a + b, 0);
      const dmm = ((mx - boxLayoutState.dragging.startX) / drawW) * totalX;
      setColWidthFromSlider(boxLayoutState.dragging.idx, +(boxLayoutState.dragging.startW + dmm).toFixed(1));
    } else if (boxLayoutState.dragging.type === "row") {
      const c = boxLayoutState.dragging.colIdx;
      const totalY = boxLayoutState.colRows[c].reduce((a, b) => a + b, 0);
      const dmm = ((my - boxLayoutState.dragging.startY) / drawH) * totalY;
      setRowDepthFromSlider(c, boxLayoutState.dragging.idx, +(boxLayoutState.dragging.startD + dmm).toFixed(1));
    }
  };
  window.onmouseup = () => { boxLayoutState.dragging = null; };
}

// ============================================================================
// 2. FASTENERS 2D SIDE-PROFILE & SHOULDER GRIP SCHEMATIC (01)
// ============================================================================
function renderFastener2D(card, vals) {
  card.style.display = "block";
  const pType = vals.part_type || "bolt";
  const spec = (vals.unit_system === "imperial") ? (vals.imperial_size || "1/4-20") : (vals.metric_size || "M8");
  const cov = vals.thread_coverage || "partial_grip";
  const gripL = parseFloat(vals.shoulder_grip_len) || 21;
  const totalL = parseFloat(vals.length) || 25;
  const slop = parseFloat(vals.printer_slop) || 0.16;

  card.innerHTML = `
    <div style="margin-bottom:5px; color:#60a5fa;"><strong>📐 2D Fastener Profile & Grip Schematic (${spec} ${pType.toUpperCase()})</strong></div>
    <canvas id="fastener-canvas" width="376" height="115" style="width:100%; height:115px; background:#0f172a; border:1px solid #3b82f6; border-radius:6px; display:block; margin-bottom:7px;"></canvas>
    ${pType === "bolt" && cov === "partial_grip" ? `
      <div style="display:flex; align-items:center; gap:6px; margin-bottom:4px;">
        <span style="font-size:0.72rem; color:#93c5fd; width:115px;">Unthreaded Grip: <strong>${gripL}mm</strong></span>
        <input type="range" min="4" max="80" step="0.5" value="${gripL}" style="flex:1; accent-color:#3b82f6;" oninput="setParamFromVisual('shoulder_grip_len', this.value)">
      </div>
    ` : (pType === "bolt" || pType === "rod") ? `
      <div style="display:flex; align-items:center; gap:6px; margin-bottom:4px;">
        <span style="font-size:0.72rem; color:#93c5fd; width:115px;">Total Length: <strong>${totalL}mm</strong></span>
        <input type="range" min="6" max="120" step="1" value="${totalL}" style="flex:1; accent-color:#3b82f6;" oninput="setParamFromVisual('length', this.value)">
      </div>
    ` : ""}
    <div style="display:flex; align-items:center; gap:6px;">
      <span style="font-size:0.72rem; color:#6ee7b7; width:115px;">Fit Slop: <strong>${slop}mm</strong></span>
      <input type="range" min="0.08" max="0.25" step="0.02" value="${slop}" style="flex:1; accent-color:#10b981;" oninput="setParamFromVisual('printer_slop', this.value)">
    </div>
  `;

  const cvs = document.getElementById("fastener-canvas");
  if (!cvs) return;
  const ctx = cvs.getContext("2d");
  ctx.clearRect(0, 0, cvs.width, cvs.height);
  const cy = cvs.height / 2;

  if (pType === "bolt") {
    const headW = 34, headH = 44;
    const shL = (cov === "partial_grip") ? Math.min(170, gripL * 4.5) : (cov === "full" ? 0 : 90);
    const thL = (cov === "partial_grip") ? 55 : (cov === "full" ? 180 : 80);

    // Bolt Head
    ctx.fillStyle = "#334155";
    ctx.strokeStyle = "#94a3b8";
    ctx.lineWidth = 2;
    ctx.fillRect(22, cy - headH/2, headW, headH);
    ctx.strokeRect(22, cy - headH/2, headW, headH);

    // Unthreaded Smooth Shoulder
    if (shL > 0) {
      ctx.fillStyle = "rgba(59, 130, 246, 0.35)";
      ctx.strokeStyle = "#60a5fa";
      ctx.fillRect(22 + headW, cy - 13, shL, 26);
      ctx.strokeRect(22 + headW, cy - 13, shL, 26);
      // Positive Nut Stop Collar
      ctx.fillStyle = "#f59e0b";
      ctx.fillRect(22 + headW + shL - 4, cy - 16, 4, 32);
    }

    // Threaded Section + Flush Nut Preview
    const tx0 = 22 + headW + shL;
    ctx.fillStyle = "rgba(16, 185, 129, 0.3)";
    ctx.strokeStyle = "#10b981";
    ctx.fillRect(tx0, cy - 12, thL, 24);
    ctx.strokeRect(tx0, cy - 12, thL, 24);
    for (let x = tx0 + 5; x < tx0 + thL - 3; x += 6) {
      ctx.beginPath(); ctx.moveTo(x, cy - 12); ctx.lineTo(x + 3, cy + 12); ctx.stroke();
    }

    if (cov === "partial_grip") {
      ctx.strokeStyle = "#fcd34d";
      ctx.setLineDash([3, 3]);
      ctx.strokeRect(tx0, cy - 22, thL, 44);
      ctx.setLineDash([]);
      ctx.fillStyle = "#fcd34d";
      ctx.font = "600 10px system-ui";
      ctx.fillText("Flush Nut Stop", tx0 + 2, cy - 26);
      ctx.fillStyle = "#93c5fd";
      ctx.fillText(`Exact Grip: ${gripL} mm`, 22 + headW + 8, cy + 28);
    }
  } else {
    ctx.fillStyle = "rgba(59, 130, 246, 0.3)";
    ctx.strokeStyle = "#60a5fa";
    ctx.lineWidth = 2;
    ctx.beginPath(); ctx.arc(cvs.width/2, cy, 36, 0, Math.PI*2); ctx.fill(); ctx.stroke();
    ctx.fillStyle = "#0f172a";
    ctx.beginPath(); ctx.arc(cvs.width/2, cy, 16, 0, Math.PI*2); ctx.fill(); ctx.stroke();
  }
}

// ============================================================================
// 3. SPACERS & STANDOFFS 2D SCHEMATIC (04)
// ============================================================================
function renderSpacer2D(card, vals) {
  card.style.display = "block";
  const L = parseFloat(vals.body_length) || 15;
  const od = parseFloat(vals.outer_diam) || 10;
  card.innerHTML = `
    <div style="margin-bottom:5px; color:#60a5fa;"><strong>📐 2D Spacer / Standoff Cross-Section (${L}mm Long × ${od}mm OD)</strong></div>
    <div style="display:flex; gap:8px;">
      <div style="flex:1;">
        <span style="font-size:0.7rem; color:#93c5fd;">Length: <strong>${L} mm</strong></span>
        <input type="range" min="2" max="60" step="0.5" value="${L}" style="width:100%; accent-color:#3b82f6;" oninput="setParamFromVisual('body_length', this.value)">
      </div>
      <div style="flex:1;">
        <span style="font-size:0.7rem; color:#6ee7b7;">Outer OD: <strong>${od} mm</strong></span>
        <input type="range" min="4" max="30" step="0.5" value="${od}" style="width:100%; accent-color:#10b981;" oninput="setParamFromVisual('outer_diam', this.value)">
      </div>
    </div>
  `;
}

// ============================================================================
// 4. CLAMPS & MOUNTS 2D CROSS-SECTION SCHEMATIC (07)
// ============================================================================
function renderClamp2D(card, vals) {
  card.style.display = "block";
  const shape = vals.profile_shape || "round";
  const cType = vals.clamp_type || "worm_band";
  const D = (shape === "square") ? (parseFloat(vals.square_width) || 25.4) : (parseFloat(vals.round_od) || 25.4);
  const HY = (shape === "square" && parseFloat(vals.square_height) > 0) ? parseFloat(vals.square_height) : D;
  const W = parseFloat(vals.band_width) || 14;
  const paramKey = (shape === "square") ? "square_width" : "round_od";

  card.innerHTML = `
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:5px;">
      <strong style="color:#60a5fa;">📐 2D Clamp Profile (${shape.toUpperCase()}: ${D}${shape==='square'?'×'+HY:''} mm)</strong>
      <div style="display:flex; gap:4px;">
        <button onclick="setParamFromVisual('profile_shape','round')" style="padding:2px 7px; font-size:0.68rem; background:${shape==='round'?'#2563eb':'#1f2937'}; color:#fff;">⭕ Round</button>
        <button onclick="setParamFromVisual('profile_shape','square')" style="padding:2px 7px; font-size:0.68rem; background:${shape==='square'?'#2563eb':'#1f2937'}; color:#fff;">⬜ Square</button>
      </div>
    </div>
    <canvas id="clamp-canvas" width="376" height="120" style="width:100%; height:120px; background:#0f172a; border:1px solid #3b82f6; border-radius:6px; display:block; margin-bottom:6px;"></canvas>
    <div style="display:flex; gap:8px;">
      <div style="flex:1;">
        <span style="font-size:0.7rem; color:#93c5fd;">${shape==='square'?'Tube Width':'Pipe OD'}: <strong>${D} mm</strong></span>
        <input type="range" min="6" max="75" step="0.5" value="${D}" style="width:100%; accent-color:#3b82f6;" oninput="setParamFromVisual('${paramKey}', this.value)">
      </div>
      <div style="flex:1;">
        <span style="font-size:0.7rem; color:#6ee7b7;">Strap Width: <strong>${W} mm</strong></span>
        <input type="range" min="8" max="35" step="1" value="${W}" style="width:100%; accent-color:#10b981;" oninput="setParamFromVisual('band_width', this.value)">
      </div>
    </div>
  `;

  const cvs = document.getElementById("clamp-canvas");
  if (!cvs) return;
  const ctx = cvs.getContext("2d");
  ctx.clearRect(0, 0, cvs.width, cvs.height);
  const cx = cvs.width / 2, cy = cvs.height / 2 + 6;
  const r = Math.min(36, Math.max(16, D * 0.9));

  ctx.strokeStyle = "#60a5fa";
  ctx.lineWidth = 7;
  if (shape === "square") {
    ctx.strokeRect(cx - r, cy - r, r * 2, r * 2);
  } else {
    ctx.beginPath(); ctx.arc(cx, cy, r, 0, Math.PI * 2); ctx.stroke();
  }
  ctx.fillStyle = "#e2e8f0";
  ctx.font = "600 11px system-ui";
  ctx.textAlign = "center";
  ctx.fillText(`${D} mm`, cx, cy + 4);
}

// ============================================================================
// 5. BRACKETS & JOINERY 2D SCHEMATIC & CSK CONTROLLER (08)
// ============================================================================
function renderBracket2D(card, vals) {
  card.style.display = "block";
  const bType = vals.bracket_type || "l_ribbed";
  const L1 = parseFloat(vals.arm_x) || 50;
  const L2 = parseFloat(vals.arm_y) || 50;
  const W  = parseFloat(vals.width) || 25;
  const T  = parseFloat(vals.thick) || 4;
  const cornerStyle = vals.inside_corner_style || "triangled";
  const csk1 = vals.csk_side_arm1 || "inside";
  const csk2 = vals.csk_side_arm2 || "inside";

  card.innerHTML = `
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">
      <strong style="color:#60a5fa;">📐 2D Bracket Schematic (Slide Arms or Toggle CSK)</strong>
    </div>
    <canvas id="bracket-canvas" width="376" height="150" style="width:100%; height:150px; background:#0f172a; border:1px solid #3b82f6; border-radius:6px; display:block; margin-bottom:8px;"></canvas>
    <div style="display:flex; gap:6px; margin-bottom:6px;">
      <div style="flex:1;">
        <span style="font-size:0.7rem; color:#93c5fd;">Arm 1 (X): <strong>${L1.toFixed(0)}mm</strong></span>
        <input type="range" min="20" max="140" step="1" value="${L1}" style="width:100%; accent-color:#3b82f6;" oninput="setParamFromVisual('arm_x', this.value)">
      </div>
      <div style="flex:1;">
        <span style="font-size:0.7rem; color:#6ee7b7;">Arm 2 (Y/Z): <strong>${L2.toFixed(0)}mm</strong></span>
        <input type="range" min="20" max="140" step="1" value="${L2}" style="width:100%; accent-color:#10b981;" oninput="setParamFromVisual('arm_y', this.value)">
      </div>
      <div style="flex:1;">
        <span style="font-size:0.7rem; color:#fcd34d;">Width: <strong>${W.toFixed(0)}mm</strong></span>
        <input type="range" min="12" max="70" step="1" value="${W}" style="width:100%; accent-color:#f59e0b;" oninput="setParamFromVisual('width', this.value)">
      </div>
    </div>
    ${(bType === "t_plate" || bType === "l_flat") ? `
      <div style="display:flex; gap:4px; margin-bottom:6px;">
        <button onclick="setParamFromVisual('inside_corner_style','triangled')" style="flex:1; padding:4px; font-size:0.7rem; background:${cornerStyle==='triangled'?'#2563eb':'#1f2937'}; color:#fff;">📐 Triangled 45°</button>
        <button onclick="setParamFromVisual('inside_corner_style','rounded')" style="flex:1; padding:4px; font-size:0.7rem; background:${cornerStyle==='rounded'?'#2563eb':'#1f2937'}; color:#fff;">➰ Rounded Fillet</button>
        <button onclick="setParamFromVisual('inside_corner_style','squared')" style="flex:1; padding:4px; font-size:0.7rem; background:${cornerStyle==='squared'?'#2563eb':'#1f2937'}; color:#fff;">⏹️ Squared 90°</button>
      </div>
    ` : ""}
    <div style="display:flex; gap:6px; font-size:0.71rem;">
      <button onclick="cycleCskMode('csk_side_arm1')" style="flex:1; padding:4px 6px; background:#1e293b; border:1px solid #3b82f6; color:#93c5fd;">🔄 Arm 1 CSK: <strong>${csk1.toUpperCase()}</strong></button>
      <button onclick="cycleCskMode('csk_side_arm2')" style="flex:1; padding:4px 6px; background:#1e293b; border:1px solid #10b981; color:#6ee7b7;">🔄 Arm 2 CSK: <strong>${csk2.toUpperCase()}</strong></button>
    </div>
  `;

  const cvs = document.getElementById("bracket-canvas");
  if (!cvs) return;
  const ctx = cvs.getContext("2d");
  ctx.clearRect(0, 0, cvs.width, cvs.height);
  const scale = Math.min(0.95, 105 / Math.max(L1, L2));
  const ox = (bType === "t_plate") ? cvs.width / 2 : 95;
  const oy = cvs.height - 24;

  ctx.fillStyle = "rgba(59, 130, 246, 0.28)";
  ctx.strokeStyle = "#60a5fa";
  ctx.lineWidth = 2;

  if (bType === "t_plate") {
    const hw = L1 * scale, bw = (W * 0.55) * scale, sh = L2 * scale;
    ctx.fillRect(ox - hw, oy - bw, hw * 2, bw);
    ctx.strokeRect(ox - hw, oy - bw, hw * 2, bw);
    ctx.fillRect(ox - bw/2, oy - bw - sh, bw, sh);
    ctx.strokeRect(ox - bw/2, oy - bw - sh, bw, sh);
    if (cornerStyle === "triangled") {
      ctx.fillStyle = "rgba(16, 185, 129, 0.45)";
      [-1, 1].forEach(s => {
        ctx.beginPath();
        ctx.moveTo(ox + s * (bw/2), oy - bw);
        ctx.lineTo(ox + s * (bw/2 + 15), oy - bw);
        ctx.lineTo(ox + s * (bw/2), oy - bw - 15);
        ctx.closePath(); ctx.fill();
      });
    }
  } else {
    const w1 = L1 * scale, h2 = L2 * scale, th = Math.max(10, T * 2.4);
    ctx.fillRect(ox, oy - th, w1, th); ctx.strokeRect(ox, oy - th, w1, th);
    ctx.fillRect(ox, oy - h2, th, h2); ctx.strokeRect(ox, oy - h2, th, h2);
    if (bType === "l_ribbed" || cornerStyle === "triangled") {
      ctx.fillStyle = "rgba(16, 185, 129, 0.35)";
      ctx.beginPath();
      ctx.moveTo(ox + th, oy - th);
      ctx.lineTo(ox + w1 * 0.72, oy - th);
      ctx.lineTo(ox + th, oy - h2 * 0.72);
      ctx.closePath(); ctx.fill();
    }
  }
  ctx.fillStyle = "#e2e8f0"; ctx.font = "600 10px system-ui";
  ctx.fillText(`Arm 1: ${L1}mm (${csk1})`, ox + 14, oy + 14);
  ctx.fillStyle = "#6ee7b7";
  ctx.fillText(`Arm 2: ${L2}mm (${csk2})`, 10, oy - (L2 * scale) / 2);
}

function cycleCskMode(paramName) {
  const order = ["inside", "outside", "both", "none"];
  const vals = collectParams();
  const curr = vals[paramName] || "inside";
  setParamFromVisual(paramName, order[(order.indexOf(curr) + 1) % order.length]);
}

// ============================================================================
// 6. KNOBS & HANDLES 2D STAR LOBE & HEX TRAP BLUEPRINT (09)
// ============================================================================
function renderKnob2D(card, vals) {
  card.style.display = "block";
  const OD = parseFloat(vals.outer_size) || 40;
  const lobes = parseInt(vals.lobes) || 5;
  const kType = vals.knob_type || "star_knob";

  card.innerHTML = `
    <div style="margin-bottom:5px; color:#60a5fa;"><strong>📐 2D Knob / Handle Blueprint (${OD} mm OD)</strong></div>
    <canvas id="knob-canvas" width="376" height="110" style="width:100%; height:110px; background:#0f172a; border:1px solid #3b82f6; border-radius:6px; display:block; margin-bottom:6px;"></canvas>
    <div style="display:flex; gap:8px;">
      <div style="flex:1;">
        <span style="font-size:0.7rem; color:#93c5fd;">Outer Diameter: <strong>${OD} mm</strong></span>
        <input type="range" min="20" max="100" step="1" value="${OD}" style="width:100%; accent-color:#3b82f6;" oninput="setParamFromVisual('outer_size', this.value)">
      </div>
      ${kType === "star_knob" ? `
      <div style="flex:1;">
        <span style="font-size:0.7rem; color:#6ee7b7;">Star Lobes: <strong>${lobes}</strong></span>
        <input type="range" min="3" max="8" step="1" value="${lobes}" style="width:100%; accent-color:#10b981;" oninput="setParamFromVisual('lobes', this.value)">
      </div>` : ""}
    </div>
  `;
  const cvs = document.getElementById("knob-canvas");
  if (!cvs) return;
  const ctx = cvs.getContext("2d");
  ctx.clearRect(0, 0, cvs.width, cvs.height);
  const cx = cvs.width / 2, cy = cvs.height / 2;
  const R = Math.min(42, Math.max(22, OD * 0.8));

  ctx.fillStyle = "rgba(59, 130, 246, 0.28)";
  ctx.strokeStyle = "#60a5fa";
  ctx.lineWidth = 2;
  ctx.beginPath();
  for (let i = 0; i <= 72; i++) {
    const a = (i / 72) * Math.PI * 2;
    const rad = (kType === "star_knob") ? (R * (0.84 + 0.16 * Math.cos(lobes * a))) : R;
    const x = cx + Math.cos(a) * rad, y = cy + Math.sin(a) * rad;
    if (i === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
  }
  ctx.closePath(); ctx.fill(); ctx.stroke();

  // Center Hex Trap
  ctx.strokeStyle = "#fcd34d";
  ctx.beginPath();
  for (let i = 0; i <= 6; i++) {
    const a = (i / 6) * Math.PI * 2;
    const x = cx + Math.cos(a) * 11, y = cy + Math.sin(a) * 11;
    if (i === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
  }
  ctx.stroke();
}

// ============================================================================
// 7. ENCLOSURES 2D FLOORPLAN DESIGNER (10)
// ============================================================================
function renderEnclosure2D(card, vals) {
  if (vals.enclosure_type === "din_clip") {
    card.style.display = "none";
    return;
  }
  card.style.display = "block";
  const IX = parseFloat(vals.inner_x) || 92;
  const IY = parseFloat(vals.inner_y) || 62;
  const IZ = parseFloat(vals.inner_z) || 30;

  card.innerHTML = `
    <div style="margin-bottom:5px; color:#60a5fa;"><strong>📐 2D Enclosure Floorplan (Interior: ${IX} × ${IY} × ${IZ} mm)</strong></div>
    <canvas id="enc-canvas" width="376" height="115" style="width:100%; height:115px; background:#0f172a; border:1px solid #3b82f6; border-radius:6px; display:block; margin-bottom:6px;"></canvas>
    <div style="display:flex; gap:6px;">
      <div style="flex:1;">
        <span style="font-size:0.7rem; color:#93c5fd;">Inner X: <strong>${IX}mm</strong></span>
        <input type="range" min="35" max="180" step="1" value="${IX}" style="width:100%; accent-color:#3b82f6;" oninput="setParamFromVisual('inner_x', this.value)">
      </div>
      <div style="flex:1;">
        <span style="font-size:0.7rem; color:#6ee7b7;">Inner Y: <strong>${IY}mm</strong></span>
        <input type="range" min="25" max="140" step="1" value="${IY}" style="width:100%; accent-color:#10b981;" oninput="setParamFromVisual('inner_y', this.value)">
      </div>
      <div style="flex:1;">
        <span style="font-size:0.7rem; color:#fcd34d;">Height Z: <strong>${IZ}mm</strong></span>
        <input type="range" min="15" max="80" step="1" value="${IZ}" style="width:100%; accent-color:#f59e0b;" oninput="setParamFromVisual('inner_z', this.value)">
      </div>
    </div>
  `;
  const cvs = document.getElementById("enc-canvas");
  if (!cvs) return;
  const ctx = cvs.getContext("2d");
  ctx.clearRect(0, 0, cvs.width, cvs.height);
  const scale = Math.min(220 / IX, 85 / IY);
  const rw = IX * scale, rh = IY * scale;
  const rx = (cvs.width - rw) / 2, ry = (cvs.height - rh) / 2;
  ctx.fillStyle = "rgba(30, 41, 59, 0.9)";
  ctx.strokeStyle = "#60a5fa";
  ctx.lineWidth = 3;
  ctx.fillRect(rx, ry, rw, rh);
  ctx.strokeRect(rx, ry, rw, rh);
  ctx.fillStyle = "#e2e8f0"; ctx.font = "600 10px system-ui"; ctx.textAlign = "center";
  ctx.fillText(`${IX} × ${IY} mm PCB Bay`, cvs.width / 2, cvs.height / 2 + 3);
}

// ============================================================================
// 8. SHOP GAUGES & CALIBRATION INSTRUCTIONS (11)
// ============================================================================
function renderGauge2D(card, vals) {
  card.style.display = "block";
  const gType = vals.gauge_type || "tolerance_test";
  if (gType === "tolerance_test") {
    card.innerHTML = `
      <div style="margin-bottom:6px; color:#60a5fa; font-size:0.8rem;">
        <strong>📏 How to Read Your Fit Slop Calibration Gauge</strong>
      </div>
      <div style="line-height:1.45; font-size:0.73rem; color:#e2e8f0;">
        <div style="background:#0f172a; padding:6px 8px; border-radius:5px; border-left:3px solid #f59e0b; margin-bottom:4px;">
          <strong style="color:#fcd34d;">1. Tight Push / Thumb-Press Fit (e.g. .08):</strong><br>
          Use for <strong>Press-Fit Hex Nut Traps</strong> (Star Knobs, Clamps) and <strong>1/4" Bit Holders</strong>.
        </div>
        <div style="background:#0f172a; padding:6px 8px; border-radius:5px; border-left:3px solid #10b981; margin-bottom:4px;">
          <strong style="color:#6ee7b7;">2. Smooth Slide / Slight Contact (e.g. .12):</strong><br>
          <strong>Your Daily Driver!</strong> Pick the smallest slot that slides in smoothly without forcing it. Use for <strong>Bolts & Nuts, Wrenches, Bits, Gears,</strong> and <strong>Snap Hinges</strong>.
        </div>
        <div style="background:#0f172a; padding:6px 8px; border-radius:5px; border-left:3px solid #3b82f6;">
          <strong style="color:#93c5fd;">3. Effortless / Zero-Drag Fit (e.g. .16 – .20):</strong><br>
          Use for <strong>Print-in-Place Bearings, Pull-Out Cabinet Drawers,</strong> and <strong>Slip Lids</strong>.
        </div>
      </div>
    `;
  } else {
    card.innerHTML = `<div style="color:#60a5fa;"><strong>🎯 Shop Gauge / Drill Guide Active (${gType})</strong></div>`;
  }
}

// ============================================================================
// 9. GASKETS & SEALS 2D BOLT-CIRCLE BLUEPRINT (12)
// ============================================================================
function renderGasket2D(card, vals) {
  card.style.display = "block";
  const gType = vals.gasket_type || "flange_bolt_circle";
  const ID = parseFloat(vals.inner_x) || 38.1;
  const RW = parseFloat(vals.rim_width) || 15;
  const T  = parseFloat(vals.thickness) || 2.0;
  const holes = parseInt(vals.bolt_count) || 4;

  card.innerHTML = `
    <div style="margin-bottom:5px; color:#60a5fa;"><strong>📐 2D Gasket & Seal Blueprint (ID: ${ID}mm | Rim: ${RW}mm | Thick: ${T}mm)</strong></div>
    <canvas id="gasket-canvas" width="376" height="110" style="width:100%; height:110px; background:#0f172a; border:1px solid #3b82f6; border-radius:6px; display:block; margin-bottom:6px;"></canvas>
    <div style="display:flex; gap:6px;">
      <div style="flex:1;">
        <span style="font-size:0.7rem; color:#93c5fd;">Inner ID: <strong>${ID}mm</strong></span>
        <input type="range" min="8" max="120" step="0.5" value="${ID}" style="width:100%; accent-color:#3b82f6;" oninput="setParamFromVisual('inner_x', this.value)">
      </div>
      <div style="flex:1;">
        <span style="font-size:0.7rem; color:#6ee7b7;">Rim Width: <strong>${RW}mm</strong></span>
        <input type="range" min="3" max="30" step="0.5" value="${RW}" style="width:100%; accent-color:#10b981;" oninput="setParamFromVisual('rim_width', this.value)">
      </div>
      <div style="flex:1;">
        <span style="font-size:0.7rem; color:#fcd34d;">Thick: <strong>${T}mm</strong></span>
        <input type="range" min="0.8" max="6" step="0.2" value="${T}" style="width:100%; accent-color:#f59e0b;" oninput="setParamFromVisual('thickness', this.value)">
      </div>
    </div>
  `;
  const cvs = document.getElementById("gasket-canvas");
  if (!cvs) return;
  const ctx = cvs.getContext("2d");
  ctx.clearRect(0, 0, cvs.width, cvs.height);
  const cx = cvs.width / 2, cy = cvs.height / 2;
  ctx.fillStyle = "rgba(16, 185, 129, 0.3)";
  ctx.strokeStyle = "#10b981";
  ctx.lineWidth = 2;
  ctx.beginPath(); ctx.arc(cx, cy, 42, 0, Math.PI * 2); ctx.fill(); ctx.stroke();
  ctx.fillStyle = "#0f172a";
  ctx.beginPath(); ctx.arc(cx, cy, 22, 0, Math.PI * 2); ctx.fill(); ctx.stroke();
  if (gType === "flange_bolt_circle" && holes > 0) {
    for (let i = 0; i < holes; i++) {
      const a = (i / holes) * Math.PI * 2;
      ctx.beginPath(); ctx.arc(cx + Math.cos(a) * 32, cy + Math.sin(a) * 32, 3.5, 0, Math.PI * 2); ctx.fill(); ctx.stroke();
    }
  }
}

// ============================================================================
// FAILSAFE AUTO-INITIALIZER (Attaches to DOM regardless of index.html layout!)
// ============================================================================
(function attachVisualSuiteHooks() {
  function boot() {
    ensureDesignerCard();
    const genSel = document.getElementById("generator-select");
    const paramsCont = document.getElementById("params-container");
    if (genSel && !genSel.dataset.visualHooked) {
      genSel.dataset.visualHooked = "1";
      genSel.addEventListener("change", () => setTimeout(() => updateMaster2DDesigner(true), 40));
    }
    if (paramsCont && !paramsCont.dataset.visualHooked) {
      paramsCont.dataset.visualHooked = "1";
      paramsCont.addEventListener("change", () => setTimeout(() => updateMaster2DDesigner(false), 20));
      paramsCont.addEventListener("input", () => setTimeout(() => updateMaster2DDesigner(false), 20));
      // Also watch when buildControls populates #params-container on initial page load
      const obs = new MutationObserver(() => setTimeout(() => updateMaster2DDesigner(false), 30));
      obs.observe(paramsCont, { childList: true });
    }
    updateMaster2DDesigner(false);
  }
  if (document.readyState === "loading") {
    window.addEventListener("DOMContentLoaded", () => setTimeout(boot, 150));
  } else {
    setTimeout(boot, 150);
  }
})();

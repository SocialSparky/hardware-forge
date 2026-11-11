// Interactive 2D Visual Cubby & Divider Designer for Hardware Forge (06_boxes_organizers.scad)
let boxLayoutState = {
  innerW: 95.2,
  innerD: 65.2,
  divT: 1.6,
  colWidths: [30, 30, 32], // Last element is always auto-remainder
  colRows: [
    [31.8, 31.8],
    [31.8, 31.8],
    [31.8, 31.8]
  ],
  selectedCol: 0,
  dragging: null // { type: 'col'|'row', colIdx: int, divIdx: int }
};

function initOrSyncBoxDesigner(forceReset = false) {
  const card = document.getElementById("box-designer-card");
  if (!currentGenerator || currentGenerator.filename !== "06_boxes_organizers.scad") {
    if (card) card.style.display = "none";
    return;
  }

  const vals = collectParams();
  if (vals.box_style === "gift_box") {
    if (card) card.style.display = "none";
    return;
  }
  if (card) card.style.display = "block";

  // Hide the raw text input for layout_spec & drawer_slot_spec since the visual designer controls them
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

  // Rebuild column count if changed or forced
  if (forceReset || boxLayoutState.colWidths.length !== targetCols) {
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

  // Rebalance rows inside each column independently
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
  if (triggerRender && document.getElementById("auto-render").checked) {
    clearTimeout(renderTimeout);
    renderTimeout = setTimeout(() => renderPart(), 180);
  }
}

function setColWidthFromSlider(colIdx, newVal) {
  const cNum = boxLayoutState.colWidths.length;
  if (colIdx >= cNum - 1) return;
  const availW = Math.max(cNum * 4, boxLayoutState.innerW - (cNum - 1) * boxLayoutState.divT);
  let otherSum = 0;
  for (let i = 0; i < cNum - 1; i++) {
    if (i !== colIdx) otherSum += boxLayoutState.colWidths[i];
  }
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
  for (let i = 0; i < rNum - 1; i++) {
    if (i !== rowIdx) otherSum += rList[i];
  }
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

function resetAllCubbiesEqual() {
  initOrSyncBoxDesigner(true);
  syncLayoutSpecToInput(true);
}

function renderBoxDesignerUI() {
  const card = document.getElementById("box-designer-card");
  if (!card) return;

  const cNum = boxLayoutState.colWidths.length;
  const selCol = Math.min(cNum - 1, boxLayoutState.selectedCol);
  const availW = Math.max(cNum * 4, boxLayoutState.innerW - (cNum - 1) * boxLayoutState.divT);
  const rList = boxLayoutState.colRows[selCol];
  const rNum = rList.length;
  const availD = Math.max(rNum * 4, boxLayoutState.innerD - (rNum - 1) * boxLayoutState.divT);

  // Build Column Sliders (1..N-1 adjustable, Nth locked as Auto-Remainder)
  let colSlidersHTML = "";
  for (let c = 0; c < cNum; c++) {
    const isLast = (c === cNum - 1);
    const val = boxLayoutState.colWidths[c].toFixed(1);
    colSlidersHTML += `
      <div style="display:flex; align-items:center; gap:6px; margin-bottom:4px; font-size:0.74rem;">
        <span style="width:52px; color:${c === selCol ? '#60a5fa' : '#9ca3af'}; font-weight:${c === selCol ? '700' : '500'}; cursor:pointer;" onclick="boxLayoutState.selectedCol=${c}; renderBoxDesignerUI();">Col ${c+1}:</span>
        ${isLast ? `
          <div style="flex:1; background:#121418; padding:3px 8px; border-radius:4px; border:1px dashed #3b82f6; color:#93c5fd;">
            Auto Remainder: <strong>${val} mm</strong>
          </div>
        ` : `
          <input type="range" min="4" max="${(availW - 4).toFixed(1)}" step="0.5" value="${val}" style="flex:1; accent-color:#3b82f6;"
            oninput="setColWidthFromSlider(${c}, this.value)">
          <input type="number" step="0.5" value="${val}" style="width:58px; padding:2px 4px; font-size:0.74rem; text-align:right;"
            onchange="setColWidthFromSlider(${c}, this.value)">
        `}
      </div>
    `;
  }

  // Build Row Sliders for Currently Selected Column (1..M-1 adjustable, Mth locked as Auto-Remainder)
  let rowSlidersHTML = "";
  for (let r = 0; r < rNum; r++) {
    const isLast = (r === rNum - 1);
    const val = rList[r].toFixed(1);
    rowSlidersHTML += `
      <div style="display:flex; align-items:center; gap:6px; margin-bottom:4px; font-size:0.74rem;">
        <span style="width:52px; color:#cbd5e1;">Row ${r+1}:</span>
        ${isLast ? `
          <div style="flex:1; background:#121418; padding:3px 8px; border-radius:4px; border:1px dashed #10b981; color:#6ee7b7;">
            Auto Remainder: <strong>${val} mm</strong>
          </div>
        ` : `
          <input type="range" min="4" max="${(availD - 4).toFixed(1)}" step="0.5" value="${val}" style="flex:1; accent-color:#10b981;"
            oninput="setRowDepthFromSlider(${selCol}, ${r}, this.value)">
          <input type="number" step="0.5" value="${val}" style="width:58px; padding:2px 4px; font-size:0.74rem; text-align:right;"
            onchange="setRowDepthFromSlider(${selCol}, ${r}, this.value)">
        `}
      </div>
    `;
  }

  // Column selector tabs
  let colTabs = "";
  for (let c = 0; c < cNum; c++) {
    const active = (c === selCol);
    colTabs += `<button onclick="boxLayoutState.selectedCol=${c}; renderBoxDesignerUI();"
      style="flex:1; padding:4px 6px; font-size:0.72rem; border-radius:4px; background:${active ? '#2563eb' : '#1f2937'}; color:${active ? '#fff' : '#9ca3af'}; border:1px solid ${active ? '#60a5fa' : '#374151'};">
      Col ${c+1} (${boxLayoutState.colRows[c].length}R)
    </button>`;
  }

  card.innerHTML = `
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">
      <strong>📐 Interactive 2D Cubby Designer (Drag Lines or Slide)</strong>
      <button onclick="resetAllCubbiesEqual()" style="width:auto; padding:2px 8px; font-size:0.7rem; background:#374151; color:#e5e7eb;">Reset Equal</button>
    </div>
    <canvas id="cubby-canvas" width="376" height="175" style="width:100%; height:175px; background:#0f172a; border:1px solid #3b82f6; border-radius:6px; cursor:move; display:block; margin-bottom:8px;"></canvas>
    <div style="font-size:0.72rem; color:#93c5fd; font-weight:700; margin-bottom:4px;">↔️ Column Widths (Usable X: ${availW.toFixed(1)} mm)</div>
    ${colSlidersHTML}
    <div style="margin-top:8px; padding-top:6px; border-top:1px solid rgba(59,130,246,0.3);">
      <div style="display:flex; gap:4px; margin-bottom:6px;">${colTabs}</div>
      <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:5px;">
        <span style="font-size:0.72rem; color:#6ee7b7; font-weight:700;">↕️ Column ${selCol+1} Rows (Usable Y: ${availD.toFixed(1)} mm)</span>
        <div style="display:flex; align-items:center; gap:4px;">
          <span style="font-size:0.7rem; color:#9ca3af;">Rows in Col ${selCol+1}:</span>
          <button onclick="changeColRowCount(${selCol}, -1)" style="width:22px; padding:1px 0; font-size:0.75rem; background:#1f2937;">-</button>
          <strong style="font-size:0.76rem; width:16px; text-align:center;">${rNum}</strong>
          <button onclick="changeColRowCount(${selCol}, 1)" style="width:22px; padding:1px 0; font-size:0.75rem; background:#1f2937;">+</button>
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

  const pad = 12;
  const drawW = W - pad * 2;
  const drawH = H - pad * 2;

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

      // Cell background
      ctx.fillStyle = (c === boxLayoutState.selectedCol) ? "rgba(37, 99, 235, 0.28)" : "rgba(30, 41, 59, 0.85)";
      ctx.fillRect(curX + 1, curY + 1, pixW - 2, pixH - 2);

      ctx.strokeStyle = (c === boxLayoutState.selectedCol) ? "#60a5fa" : "#475569";
      ctx.lineWidth = 1.5;
      ctx.strokeRect(curX + 1, curY + 1, pixW - 2, pixH - 2);

      // Dimensions label inside cell
      ctx.fillStyle = "#e2e8f0";
      ctx.font = "600 10px system-ui, sans-serif";
      ctx.textAlign = "center";
      ctx.textBaseline = "middle";
      if (pixW > 34 && pixH > 18) {
        ctx.fillText(`${cw.toFixed(0)}×${rd.toFixed(0)}`, curX + pixW / 2, curY + pixH / 2);
      }

      // Draw draggable horizontal row handle line
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

    // Draw draggable vertical column handle line
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
  const pad = 12;

  cvs.onmousedown = (e) => {
    const rect = cvs.getBoundingClientRect();
    const mx = (e.clientX - rect.left) * (cvs.width / rect.width);
    const my = (e.clientY - rect.top) * (cvs.height / rect.height);
    const drawW = cvs.width - pad * 2;
    const drawH = cvs.height - pad * 2;
    const totalX = boxLayoutState.colWidths.reduce((a, b) => a + b, 0);

    // 1. Check if near a vertical column divider
    let curX = pad;
    for (let c = 0; c < boxLayoutState.colWidths.length - 1; c++) {
      curX += (boxLayoutState.colWidths[c] / totalX) * drawW;
      if (Math.abs(mx - curX) <= 7) {
        boxLayoutState.dragging = { type: "col", idx: c, startX: mx, startW: boxLayoutState.colWidths[c] };
        return;
      }
    }

    // 2. Determine which column was clicked & check if near a horizontal row divider
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
    const drawW = cvsEl.width - pad * 2;
    const drawH = cvsEl.height - pad * 2;

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

  window.onmouseup = () => {
    boxLayoutState.dragging = null;
  };
}

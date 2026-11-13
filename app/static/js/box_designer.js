
function getActiveGeneratorFilename() {
  if (typeof currentGenerator !== "undefined" && currentGenerator && currentGenerator.filename) {
    return currentGenerator.filename;
  }
  var sel = document.getElementById("generator-select");
  if (!sel) return "";
  var v = String(sel.value || "");
  if (v.indexOf(".scad") !== -1) return v;
  if (typeof generators !== "undefined" && Array.isArray(generators)) {
    var idx = parseInt(v, 10);
    if (!isNaN(idx) && generators[idx] && generators[idx].filename) {
      return generators[idx].filename;
    }
  }
  var opt = sel.options[sel.selectedIndex];
  var txt = opt ? (opt.textContent || "").toLowerCase() : "";
  if (txt.indexOf("box") !== -1 || txt.indexOf("organizer") !== -1) return "06_boxes_organizers.scad";
  if (txt.indexOf("fastener") !== -1) return "01_fasteners.scad";
  if (txt.indexOf("spacer") !== -1 || txt.indexOf("standoff") !== -1) return "04_spacers_standoffs.scad";
  if (txt.indexOf("clamp") !== -1) return "07_clamps_mounts.scad";
  if (txt.indexOf("bracket") !== -1) return "08_brackets_joinery.scad";
  if (txt.indexOf("knob") !== -1) return "09_knobs_handles.scad";
  if (txt.indexOf("enclosure") !== -1) return "10_enclosures_plates.scad";
  if (txt.indexOf("gauge") !== -1 || txt.indexOf("jig") !== -1) return "11_gauges_jigs.scad";
  if (txt.indexOf("gasket") !== -1 || txt.indexOf("seal") !== -1) return "12_gaskets_seals.scad";
  return v;
}

// ============================================================================
// HARDWARE FORGE — 9-CATEGORY 2D VISUAL DESIGNER & 3D MULTI-COLOR LID SUITE
// ============================================================================

var lidPreviewColors = {
  box: "#1e293b",
  frame: "#f59e0b",
  text: "#38bdf8"
};

var boxLayoutState = {
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

var lidState = {
  mode: "debossed",
  line1: "M5 HARDWARE",
  line2: "",
  font: "Liberation Sans:style=Bold",
  size: 10.0,
  frame: "rounded_box",
  depth: 0.6,
  textX: 0.0,
  textY: 0.0,
  marginX: 8.0,
  marginY: 8.0
};

var lidDragState = null;
var lidHitBoxes = {
  scale: 1, ox: 0, oy: 0, drawW: 100, drawD: 70, boxW: 100, boxD: 70,
  textRect: null, textHandle: null, frameRightHandle: null, frameBottomHandle: null
};

function ensureDesignerCard() {
  var card = document.getElementById("box-designer-card");
  if (!card) {
    var paramsCont = document.getElementById("params-container");
    if (paramsCont && paramsCont.parentNode) {
      card = document.createElement("div");
      card.id = "box-designer-card";
      card.style.cssText = "margin:10px 18px 4px 18px; padding:10px 12px; background:rgba(15, 23, 42, 0.94); border:1px solid #3b82f6; border-radius:6px; font-size:0.75rem; color:#dbeafe; display:none; box-shadow:0 4px 12px rgba(0,0,0,0.35);";
      paramsCont.parentNode.insertBefore(card, paramsCont);
    }
  }
  return card;
}

function ensureParamInputExists(paramName, defaultVal) {
  var el = document.querySelector('[data-param="' + paramName + '"]');
  if (!el) {
    var cont = document.getElementById("params-container");
    if (cont) {
      el = document.createElement("input");
      el.type = "hidden";
      el.setAttribute("data-param", paramName);
      el.value = String(defaultVal);
      cont.appendChild(el);
    }
  }
  return el;
}

function setParamFromVisual(paramName, val) {
  var el = ensureParamInputExists(paramName, val);
  if (!el) return;
  if (el.tagName === "SELECT") {
    var matchOpt = Array.from(el.options).find(function(o) { return String(o.value) === String(val); });
    if (matchOpt) {
      el.value = String(val);
      var custWrap = document.getElementById("custom-wrap-" + paramName);
      if (custWrap) custWrap.style.display = "none";
    } else {
      var custOpt = Array.from(el.options).find(function(o) { return o.value === "__custom__"; });
      if (custOpt) {
        el.value = "__custom__";
        var custWrap2 = document.getElementById("custom-wrap-" + paramName);
        if (custWrap2) custWrap2.style.display = "flex";
        var custInp = document.querySelector('[data-custom-for="' + paramName + '"]');
        if (custInp) {
          custInp.value = String(val);
          var unitSel = document.querySelector('[data-unit-for="' + paramName + '"]');
          if (unitSel) unitSel.value = "mm";
        }
      }
    }
  } else {
    el.value = String(val);
  }
  if (typeof updateVisibility === "function") updateVisibility();
  updateMaster2DDesigner(false);
  var autoChk = document.getElementById("auto-render");
  if (autoChk && autoChk.checked && typeof renderPart === "function") {
    clearTimeout(window.renderTimeout);
    window.renderTimeout = setTimeout(function() { renderPart(); }, 220);
  }
}

function updateMaster2DDesigner(forceReset) {
  if (typeof refreshPresetDropdownForCurrentCategory === "function") {
    refreshPresetDropdownForCurrentCategory();
  }
  var card = ensureDesignerCard();
  var fname = getActiveGeneratorFilename();
  if (!card || !fname) return;
  var vals = (typeof collectParams === "function") ? collectParams() : {};

  if (fname === "06_boxes_organizers.scad") {
    initOrSyncBoxDesigner(Boolean(forceReset));
  } else {
    clearMultiColor3DOverlays();
    var m = findMainStlMeshInScene();
    if (m && m.material) m.material.color.set(0x3b82f6);

    if (fname === "01_fasteners.scad") {
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
}

// ============================================================================
// 1. BOXES & ORGANIZERS: 2D CUBBY + 2D/3D MULTI-COLOR LID DESIGNER
// ============================================================================
function hideRedundantLidSidebarControls() {
  var lidParams = [
    "lid_label_mode", "lid_text_line1", "lid_text_line2",
    "lid_font", "lid_text_size", "lid_frame_style", "inlay_depth",
    "lid_text_x", "lid_text_y", "lid_frame_margin_x", "lid_frame_margin_y",
    "layout_spec", "drawer_slot_spec"
  ];
  lidParams.forEach(function(k) {
    var w = document.getElementById("wrap-" + k);
    if (w) {
      w.style.display = "none";
      var grp = w.closest(".param-group");
      if (grp && grp.textContent.indexOf("Multi-Color Lid Text") !== -1) {
        grp.style.display = "none";
      }
    }
  });
}

function initOrSyncBoxDesigner(forceReset) {
  var card = ensureDesignerCard();
  if (!card) return;
  card.style.display = "block";
  hideRedundantLidSidebarControls();

  var vals = collectParams();
  var W = parseFloat(vals.outer_width) || 100;
  var D = parseFloat(vals.outer_depth) || 70;
  var T = parseFloat(vals.wall_thick) || 2.4;
  var divT = parseFloat(vals.divider_thick) || 1.6;
  var targetCols = Math.max(1, Math.round(parseFloat(vals.cols) || 3));
  var defaultRows = Math.max(1, Math.round(parseFloat(vals.rows) || 2));

  boxLayoutState.innerW = Math.max(10, W - 2 * T);
  boxLayoutState.innerD = Math.max(10, D - 2 * T);
  boxLayoutState.divT = divT;

  var colsChanged = (targetCols !== boxLayoutState.lastColsParam);
  var rowsChanged = (defaultRows !== boxLayoutState.lastRowsParam);

  if (forceReset || boxLayoutState.colWidths.length !== targetCols || colsChanged || rowsChanged) {
    boxLayoutState.lastColsParam = targetCols;
    boxLayoutState.lastRowsParam = defaultRows;
    var availW = Math.max(targetCols * 4, boxLayoutState.innerW - (targetCols - 1) * divT);
    var eqW = +(availW / targetCols).toFixed(1);
    boxLayoutState.colWidths = Array(targetCols).fill(eqW);
    boxLayoutState.colRows = [];
    for (var c = 0; c < targetCols; c++) {
      var availD = Math.max(defaultRows * 4, boxLayoutState.innerD - (defaultRows - 1) * divT);
      var eqD = +(availD / defaultRows).toFixed(1);
      boxLayoutState.colRows.push(Array(defaultRows).fill(eqD));
    }
    if (boxLayoutState.selectedCol >= targetCols) boxLayoutState.selectedCol = 0;
  }

  rebalanceBoxRemainders();
  renderBoxDesignerUI();
  syncLayoutSpecToInput(false);
  pushLidStateToDOM();
}

function rebalanceBoxRemainders() {
  var cNum = boxLayoutState.colWidths.length;
  var divT = boxLayoutState.divT;
  var availW = Math.max(cNum * 4, boxLayoutState.innerW - (cNum - 1) * divT);
  var minCell = 4.0;

  if (cNum === 1) {
    boxLayoutState.colWidths[0] = +availW.toFixed(1);
  } else {
    var sumFirst = 0;
    for (var i = 0; i < cNum - 1; i++) {
      boxLayoutState.colWidths[i] = Math.max(minCell, +boxLayoutState.colWidths[i] || minCell);
      sumFirst += boxLayoutState.colWidths[i];
    }
    var maxFirst = availW - minCell;
    if (sumFirst > maxFirst && sumFirst > 0) {
      var scale = maxFirst / sumFirst;
      sumFirst = 0;
      for (var j = 0; j < cNum - 1; j++) {
        boxLayoutState.colWidths[j] = +(boxLayoutState.colWidths[j] * scale).toFixed(1);
        sumFirst += boxLayoutState.colWidths[j];
      }
    }
    boxLayoutState.colWidths[cNum - 1] = +(availW - sumFirst).toFixed(1);
  }

  for (var c = 0; c < cNum; c++) {
    var rList = boxLayoutState.colRows[c];
    var rNum = rList.length;
    var availD = Math.max(rNum * 4, boxLayoutState.innerD - (rNum - 1) * divT);
    if (rNum === 1) {
      rList[0] = +availD.toFixed(1);
    } else {
      var sumR = 0;
      for (var r = 0; r < rNum - 1; r++) {
        rList[r] = Math.max(minCell, +rList[r] || minCell);
        sumR += rList[r];
      }
      var maxR = availD - minCell;
      if (sumR > maxR && sumR > 0) {
        var scaleR = maxR / sumR;
        sumR = 0;
        for (var r2 = 0; r2 < rNum - 1; r2++) {
          rList[r2] = +(rList[r2] * scaleR).toFixed(1);
          sumR += rList[r2];
        }
      }
      rList[rNum - 1] = +(availD - sumR).toFixed(1);
    }
  }
}

function syncLayoutSpecToInput(triggerRender) {
  var inp = ensureParamInputExists("layout_spec", "");
  if (!inp) return;
  var parts = [];
  for (var c = 0; c < boxLayoutState.colWidths.length; c++) {
    var w = boxLayoutState.colWidths[c].toFixed(1);
    var rStr = boxLayoutState.colRows[c].map(function(v) { return v.toFixed(1); }).join(",");
    parts.push(w + ":" + rStr);
  }
  inp.value = parts.join("|");
  if (triggerRender && document.getElementById("auto-render") && document.getElementById("auto-render").checked) {
    clearTimeout(window.renderTimeout);
    window.renderTimeout = setTimeout(function() { renderPart(); }, 200);
  }
}

function setColWidthFromSlider(colIdx, newVal) {
  var cNum = boxLayoutState.colWidths.length;
  if (colIdx >= cNum - 1) return;
  var availW = Math.max(cNum * 4, boxLayoutState.innerW - (cNum - 1) * boxLayoutState.divT);
  var otherSum = 0;
  for (var i = 0; i < cNum - 1; i++) if (i !== colIdx) otherSum += boxLayoutState.colWidths[i];
  var maxAllowed = Math.max(4.0, availW - otherSum - 4.0);
  boxLayoutState.colWidths[colIdx] = Math.min(maxAllowed, Math.max(4.0, parseFloat(newVal) || 4.0));
  rebalanceBoxRemainders();
  renderBoxDesignerUI();
  syncLayoutSpecToInput(true);
}

function setRowDepthFromSlider(colIdx, rowIdx, newVal) {
  var rList = boxLayoutState.colRows[colIdx];
  var rNum = rList.length;
  if (rowIdx >= rNum - 1) return;
  var availD = Math.max(rNum * 4, boxLayoutState.innerD - (rNum - 1) * boxLayoutState.divT);
  var otherSum = 0;
  for (var i = 0; i < rNum - 1; i++) if (i !== rowIdx) otherSum += rList[i];
  var maxAllowed = Math.max(4.0, availD - otherSum - 4.0);
  rList[rowIdx] = Math.min(maxAllowed, Math.max(4.0, parseFloat(newVal) || 4.0));
  rebalanceBoxRemainders();
  renderBoxDesignerUI();
  syncLayoutSpecToInput(true);
}

function changeColRowCount(colIdx, delta) {
  var rList = boxLayoutState.colRows[colIdx];
  var newCount = Math.min(8, Math.max(1, rList.length + delta));
  var availD = Math.max(newCount * 4, boxLayoutState.innerD - (newCount - 1) * boxLayoutState.divT);
  var eqD = +(availD / newCount).toFixed(1);
  boxLayoutState.colRows[colIdx] = Array(newCount).fill(eqD);
  rebalanceBoxRemainders();
  renderBoxDesignerUI();
  syncLayoutSpecToInput(true);
}

function changeTotalColsCount(delta) {
  var vals = collectParams();
  var cur = Math.max(1, Math.round(parseFloat(vals.cols) || 3));
  var next = Math.min(8, Math.max(1, cur + delta));
  setParamFromVisual("cols", next);
}

function resetAllCubbiesEqual() {
  initOrSyncBoxDesigner(true);
  syncLayoutSpecToInput(true);
}

function renderBoxDesignerUI() {
  var card = ensureDesignerCard();
  if (!card) return;
  hideRedundantLidSidebarControls();

  var activeId = document.activeElement ? document.activeElement.id : null;
  if (activeId === "lid-input-line1" || activeId === "lid-input-line2") {
    drawCubbyCanvas();
    drawLidLabelPreviewCanvas();
    return;
  }

  var vals = collectParams();
  var boxStyle = vals.box_style || "hinged_box";
  var showCubbies = (boxStyle !== "gift_box");
  var showLidDesigner = (boxStyle === "hinged_box" || boxStyle === "slide_box" || boxStyle === "gift_box");

  var cNum = boxLayoutState.colWidths.length;
  var selCol = Math.min(cNum - 1, boxLayoutState.selectedCol);
  var availW = Math.max(cNum * 4, boxLayoutState.innerW - (cNum - 1) * boxLayoutState.divT);
  var rList = boxLayoutState.colRows[selCol];
  var rNum = rList.length;
  var availD = Math.max(rNum * 4, boxLayoutState.innerD - (rNum - 1) * boxLayoutState.divT);

  var colSlidersHTML = "";
  for (var c = 0; c < cNum; c++) {
    var isLast = (c === cNum - 1);
    var val = boxLayoutState.colWidths[c].toFixed(1);
    colSlidersHTML += '<div style="display:flex; align-items:center; gap:6px; margin-bottom:4px; font-size:0.73rem;">' +
      '<span style="width:48px; color:' + (c === selCol ? '#60a5fa' : '#9ca3af') + '; font-weight:' + (c === selCol ? '700' : '500') + '; cursor:pointer;" onclick="boxLayoutState.selectedCol=' + c + '; renderBoxDesignerUI();">Col ' + (c+1) + ':</span>' +
      (isLast ?
        '<div style="flex:1; background:#121418; padding:2px 8px; border-radius:4px; border:1px dashed #3b82f6; color:#93c5fd;">Auto Remainder: <strong>' + val + ' mm</strong></div>' :
        '<input type="range" min="4" max="' + (availW - 4).toFixed(1) + '" step="0.5" value="' + val + '" style="flex:1; accent-color:#3b82f6;" oninput="setColWidthFromSlider(' + c + ', this.value)">' +
        '<input type="number" step="0.5" value="' + val + '" style="width:54px; padding:2px 4px; font-size:0.73rem; text-align:right;" onchange="setColWidthFromSlider(' + c + ', this.value)">'
      ) + '</div>';
  }

  var rowSlidersHTML = "";
  for (var r = 0; r < rNum; r++) {
    var isLastR = (r === rNum - 1);
    var valR = rList[r].toFixed(1);
    rowSlidersHTML += '<div style="display:flex; align-items:center; gap:6px; margin-bottom:4px; font-size:0.73rem;">' +
      '<span style="width:48px; color:#cbd5e1;">Row ' + (r+1) + ':</span>' +
      (isLastR ?
        '<div style="flex:1; background:#121418; padding:2px 8px; border-radius:4px; border:1px dashed #10b981; color:#6ee7b7;">Auto Remainder: <strong>' + valR + ' mm</strong></div>' :
        '<input type="range" min="4" max="' + (availD - 4).toFixed(1) + '" step="0.5" value="' + valR + '" style="flex:1; accent-color:#10b981;" oninput="setRowDepthFromSlider(' + selCol + ', ' + r + ', this.value)">' +
        '<input type="number" step="0.5" value="' + valR + '" style="width:54px; padding:2px 4px; font-size:0.73rem; text-align:right;" onchange="setRowDepthFromSlider(' + selCol + ', ' + r + ', this.value)">'
      ) + '</div>';
  }

  var colTabs = "";
  for (var ct = 0; ct < cNum; ct++) {
    var active = (ct === selCol);
    colTabs += '<button onclick="boxLayoutState.selectedCol=' + ct + '; renderBoxDesignerUI();" ' +
      'style="flex:1; padding:3px 5px; font-size:0.71rem; border-radius:4px; background:' + (active ? '#2563eb' : '#1f2937') + '; color:' + (active ? '#fff' : '#9ca3af') + '; border:1px solid ' + (active ? '#60a5fa' : '#374151') + ';">' +
      'Col ' + (ct+1) + ' (' + boxLayoutState.colRows[ct].length + 'R)</button>';
  }

  var safeL1 = String(lidState.line1 || "").replace(/"/g, "&quot;");
  var safeL2 = String(lidState.line2 || "").replace(/"/g, "&quot;");

  var html = "";
  if (showCubbies) {
    html += '<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">' +
      '<strong style="color:#60a5fa;">📐 1. 2D Cubby & Divider Layout (Drag Lines or Slide)</strong>' +
      '<button onclick="resetAllCubbiesEqual()" style="width:auto; padding:2px 8px; font-size:0.68rem; background:#374151; color:#e5e7eb;">Reset Equal</button>' +
      '</div>' +
      '<canvas id="cubby-canvas" width="376" height="145" style="width:100%; height:145px; background:#0f172a; border:1px solid #3b82f6; border-radius:6px; cursor:move; display:block; margin-bottom:8px;"></canvas>' +
      '<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:4px;">' +
      '<span style="font-size:0.72rem; color:#93c5fd; font-weight:700;">↔️ Columns (Usable X: ' + availW.toFixed(1) + ' mm)</span>' +
      '<div style="display:flex; align-items:center; gap:4px;">' +
      '<span style="font-size:0.69rem; color:#9ca3af;">Cols:</span>' +
      '<button onclick="changeTotalColsCount(-1)" style="width:22px; padding:1px 0; font-size:0.74rem; background:#1f2937;">-</button>' +
      '<strong style="font-size:0.74rem; width:14px; text-align:center;">' + cNum + '</strong>' +
      '<button onclick="changeTotalColsCount(1)" style="width:22px; padding:1px 0; font-size:0.74rem; background:#1f2937;">+</button>' +
      '</div></div>' + colSlidersHTML +
      '<div style="margin-top:7px; padding-top:6px; border-top:1px solid rgba(59,130,246,0.3);">' +
      '<div style="display:flex; gap:4px; margin-bottom:6px;">' + colTabs + '</div>' +
      '<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:4px;">' +
      '<span style="font-size:0.72rem; color:#6ee7b7; font-weight:700;">↕️ Col ' + (selCol+1) + ' Rows (Usable Y: ' + availD.toFixed(1) + ' mm)</span>' +
      '<div style="display:flex; align-items:center; gap:4px;">' +
      '<span style="font-size:0.69rem; color:#9ca3af;">Rows in Col ' + (selCol+1) + ':</span>' +
      '<button onclick="changeColRowCount(' + selCol + ', -1)" style="width:22px; padding:1px 0; font-size:0.74rem; background:#1f2937;">-</button>' +
      '<strong style="font-size:0.74rem; width:14px; text-align:center;">' + rNum + '</strong>' +
      '<button onclick="changeColRowCount(' + selCol + ', 1)" style="width:22px; padding:1px 0; font-size:0.74rem; background:#1f2937;">+</button>' +
      '</div></div>' + rowSlidersHTML + '</div>';
  }

  if (showLidDesigner) {
    html += '<div id="lid-label-preview-wrap" style="margin-top:' + (showCubbies ? '10px' : '0') + '; padding-top:' + (showCubbies ? '8px' : '0') + '; border-top:' + (showCubbies ? '2px solid rgba(245,158,11,0.45)' : 'none') + ';">' +
      (boxStyle === "hinged_box" ?
        '<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px; padding:5px 8px; background:#0f172a; border:1px solid #10b981; border-radius:5px;">' +
        '<span style="font-size:0.73rem; color:#6ee7b7; font-weight:700;">🔒 Clasp Tightness:</span>' +
        '<select style="width:auto; flex:1; margin-left:8px; padding:3px 6px; font-size:0.72rem; background:#1e293b; color:#f8fafc; border:1px solid #10b981; border-radius:4px;" onchange="setParamFromVisual(\'clasp_bite\', this.value)">' +
        '<option value="0.15"' + (String(vals.clasp_bite)==="0.15"?" selected":"") + '>🧸 0.15 mm — Kid-Friendly (Featherlight)</option>' +
        '<option value="0.25"' + ((!vals.clasp_bite || String(vals.clasp_bite)==="0.25")?" selected":"") + '>👍 0.25 mm — Easy Everyday (Default)</option>' +
        '<option value="0.35"' + (String(vals.clasp_bite)==="0.35"?" selected":"") + '>🧰 0.35 mm — Medium Snug</option>' +
        '<option value="0.45"' + (String(vals.clasp_bite)==="0.45"?" selected":"") + '>🔒 0.45 mm — Firm Toolbag Grip</option>' +
        '<option value="0.60"' + (String(vals.clasp_bite)==="0.60" || String(vals.clasp_bite)==="0.65"?" selected":"") + '>🏋️ 0.60 mm — Heavy Duty Lock</option>' +
        '</select></div>' : ''
      ) +
      '<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">' +
      '<span style="font-size:0.74rem; color:#60a5fa; font-weight:700;">🔪 2. 2D Lid Engraved Cutout Designer (Wording & Frame)</span>' +
      '</div>' +

      '<div style="display:flex; gap:4px; margin-bottom:5px;">' +
      '<select id="lid-quick-mode" style="flex:1.1; padding:3px 4px; font-size:0.7rem; background:#0f172a; color:#60a5fa; border:1px solid #3b82f6; border-radius:4px;" onchange="setLidControlFromPreview(\'mode\', this.value)">' +
      '<option value="debossed"' + (lidState.mode!=='none'?' selected':'') + '>🔪 Engraved Cutout (On)</option>' +
      '<option value="none"' + (lidState.mode==='none'?' selected':'') + '>🚫 Plain Lid (Off)</option>' +
      '</select>' +
      '<select id="lid-quick-frame" style="flex:1.1; padding:3px 4px; font-size:0.7rem; background:#0f172a; color:#fcd34d; border:1px solid #475569; border-radius:4px;" onchange="setLidControlFromPreview(\'frame\', this.value)">' +
      '<option value="rounded_box"' + (lidState.frame==='rounded_box'?' selected':'') + '>⬜ Rounded Frame</option>' +
      '<option value="chamfer_tag"' + (lidState.frame==='chamfer_tag'?' selected':'') + '>🛑 Octagon Frame</option>' +
      '<option value="double_line"' + (lidState.frame==='double_line'?' selected':'') + '>♊ Double Pinstripe</option>' +
      '<option value="corner_brackets"' + (lidState.frame==='corner_brackets'?' selected':'') + '>🎯 Corner Brackets</option>' +
      '<option value="none"' + (lidState.frame==='none'?' selected':'') + '>🔤 No Frame</option>' +
      '</select>' +
      '<select id="lid-quick-font" style="flex:1; padding:3px 4px; font-size:0.7rem; background:#0f172a; color:#e2e8f0; border:1px solid #475569; border-radius:4px;" onchange="setLidControlFromPreview(\'font\', this.value)">' +
      '<option value="Liberation Sans:style=Bold"' + (lidState.font.indexOf('Liberation Sans')!==-1?' selected':'') + '>Bold Sans</option>' +
      '<option value="Liberation Mono:style=Bold"' + (lidState.font.indexOf('Mono')!==-1?' selected':'') + '>Tech Mono</option>' +
      '<option value="DejaVu Sans:style=Bold"' + (lidState.font.indexOf('DejaVu')!==-1?' selected':'') + '>Wide Heavy</option>' +
      '<option value="Liberation Serif:style=Bold"' + (lidState.font.indexOf('Serif')!==-1?' selected':'') + '>Bold Serif</option>' +
      '</select></div>' +

      '<div style="display:flex; gap:5px; margin-bottom:6px;">' +
      '<input id="lid-input-line1" type="text" placeholder="Line 1 (e.g. M5 HARDWARE)" value="' + safeL1 + '" style="flex:1.2; padding:4px 7px; font-size:0.73rem; background:#0f172a; color:#f8fafc; border:1px solid #38bdf8; border-radius:4px; font-weight:600;" oninput="onLidTextInput(\'line1\', this.value)">' +
      '<input id="lid-input-line2" type="text" placeholder="Line 2 (Optional Subtitle)" value="' + safeL2 + '" style="flex:1; padding:4px 7px; font-size:0.73rem; background:#0f172a; color:#93c5fd; border:1px solid #475569; border-radius:4px;" oninput="onLidTextInput(\'line2\', this.value)">' +
      '</div>' +

      '<canvas id="lid-label-canvas" width="376" height="145" style="width:100%; height:145px; background:#090d16; border:1px solid #f59e0b; border-radius:6px; display:block; margin-bottom:6px;"></canvas>' +

      '<div style="display:flex; align-items:center; gap:6px; margin-bottom:3px; font-size:0.71rem;">' +
      '<span style="color:#93c5fd; width:92px;">Font Size: <strong id="lid-font-size-lbl">' + lidState.size.toFixed(1) + 'mm</strong></span>' +
      '<input id="lid-font-size-slider" type="range" min="4" max="26" step="0.5" value="' + lidState.size + '" style="flex:1; accent-color:#38bdf8;" oninput="lidState.size=parseFloat(this.value)||10; document.getElementById(\'lid-font-size-lbl\').textContent=lidState.size.toFixed(1)+\'mm\'; drawLidLabelPreviewCanvas(); triggerDebouncedLidRender();">' +
      '<button onclick="resetLidLabelLayout()" style="width:auto; padding:2px 7px; font-size:0.67rem; background:#334155; color:#f8fafc; border-radius:4px;">Center Reset</button>' +
      '</div>' +
      '<div style="font-size:0.66rem; color:#94a3b8;">🖱️ <strong>Drag wording</strong> to move • <strong>Drag 🔵</strong> to scale text • <strong>Drag 🟧</strong> to resize frame</div>' +
      '</div>';
  }

  card.innerHTML = html;

  if (showCubbies) {
    drawCubbyCanvas();
    bindCanvasDragEvents();
  }
  if (showLidDesigner) {
    drawLidLabelPreviewCanvas();
  }
}

function drawCubbyCanvas() {
  var cvs = document.getElementById("cubby-canvas");
  if (!cvs) return;
  var ctx = cvs.getContext("2d");
  var W = cvs.width, H = cvs.height;
  ctx.clearRect(0, 0, W, H);
  var pad = 10, drawW = W - pad * 2, drawH = H - pad * 2;
  var totalX = boxLayoutState.colWidths.reduce(function(a, b) { return a + b; }, 0) || 1;
  var curX = pad;

  for (var c = 0; c < boxLayoutState.colWidths.length; c++) {
    var cw = boxLayoutState.colWidths[c];
    var pixW = (cw / totalX) * drawW;
    var rList = boxLayoutState.colRows[c] || [1];
    var totalY = rList.reduce(function(a, b) { return a + b; }, 0) || 1;
    var curY = pad;

    for (var r = 0; r < rList.length; r++) {
      var rd = rList[r];
      var pixH = (rd / totalY) * drawH;
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
        ctx.fillText(cw.toFixed(0) + "×" + rd.toFixed(0), curX + pixW / 2, curY + pixH / 2);
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
  var cvs = document.getElementById("cubby-canvas");
  if (!cvs) return;
  var pad = 10;
  cvs.onmousedown = function(e) {
    var rect = cvs.getBoundingClientRect();
    var mx = (e.clientX - rect.left) * (cvs.width / rect.width);
    var my = (e.clientY - rect.top) * (cvs.height / rect.height);
    var drawW = cvs.width - pad * 2, drawH = cvs.height - pad * 2;
    var totalX = boxLayoutState.colWidths.reduce(function(a, b) { return a + b; }, 0) || 1;
    var curX = pad;
    for (var c = 0; c < boxLayoutState.colWidths.length - 1; c++) {
      curX += (boxLayoutState.colWidths[c] / totalX) * drawW;
      if (Math.abs(mx - curX) <= 7) {
        boxLayoutState.dragging = { type: "col", idx: c, startX: mx, startW: boxLayoutState.colWidths[c] };
        return;
      }
    }
    curX = pad;
    for (var c2 = 0; c2 < boxLayoutState.colWidths.length; c2++) {
      var pixW = (boxLayoutState.colWidths[c2] / totalX) * drawW;
      if (mx >= curX && mx <= curX + pixW) {
        boxLayoutState.selectedCol = c2;
        var rList = boxLayoutState.colRows[c2];
        var totalY = rList.reduce(function(a, b) { return a + b; }, 0) || 1;
        var curY = pad;
        for (var r = 0; r < rList.length - 1; r++) {
          curY += (rList[r] / totalY) * drawH;
          if (Math.abs(my - curY) <= 7) {
            boxLayoutState.dragging = { type: "row", colIdx: c2, idx: r, startY: my, startD: rList[r] };
            return;
          }
        }
        renderBoxDesignerUI();
        return;
      }
      curX += pixW;
    }
  };
}

window.addEventListener("mousemove", function(e) {
  if (boxLayoutState.dragging) {
    var cvsEl = document.getElementById("cubby-canvas");
    if (!cvsEl) return;
    var pad = 10;
    var rect = cvsEl.getBoundingClientRect();
    var mx = (e.clientX - rect.left) * (cvsEl.width / rect.width);
    var my = (e.clientY - rect.top) * (cvsEl.height / rect.height);
    var drawW = cvsEl.width - pad * 2, drawH = cvsEl.height - pad * 2;
    if (boxLayoutState.dragging.type === "col") {
      var totalX = boxLayoutState.colWidths.reduce(function(a, b) { return a + b; }, 0) || 1;
      var dmm = ((mx - boxLayoutState.dragging.startX) / drawW) * totalX;
      setColWidthFromSlider(boxLayoutState.dragging.idx, +(boxLayoutState.dragging.startW + dmm).toFixed(1));
    } else if (boxLayoutState.dragging.type === "row") {
      var c = boxLayoutState.dragging.colIdx;
      var totalY = boxLayoutState.colRows[c].reduce(function(a, b) { return a + b; }, 0) || 1;
      var dmmY = ((my - boxLayoutState.dragging.startY) / drawH) * totalY;
      setRowDepthFromSlider(c, boxLayoutState.dragging.idx, +(boxLayoutState.dragging.startD + dmmY).toFixed(1));
    }
  }
});

window.addEventListener("mouseup", function() {
  boxLayoutState.dragging = null;
});

function drawSafeRoundRect(ctx, x, y, w, h, r) {
  var rad = Math.max(0, Math.min(r, Math.min(w, h) / 2));
  ctx.beginPath();
  ctx.moveTo(x + rad, y);
  ctx.lineTo(x + w - rad, y);
  ctx.quadraticCurveTo(x + w, y, x + w, y + rad);
  ctx.lineTo(x + w, y + h - rad);
  ctx.quadraticCurveTo(x + w, y + h, x + w - rad, y + h);
  ctx.lineTo(x + rad, y + h);
  ctx.quadraticCurveTo(x, y + h, x, y + h - rad);
  ctx.lineTo(x, y + rad);
  ctx.quadraticCurveTo(x, y, x + rad, y);
  ctx.closePath();
}

function pushLidStateToDOM() {
  var pairs = {
    lid_label_mode: lidState.mode,
    lid_text_line1: lidState.line1,
    lid_text_line2: lidState.line2,
    lid_font: lidState.font,
    lid_text_size: lidState.size,
    lid_frame_style: lidState.frame,
    inlay_depth: lidState.depth,
    lid_text_x: lidState.textX,
    lid_text_y: lidState.textY,
    lid_frame_margin_x: lidState.marginX,
    lid_frame_margin_y: lidState.marginY
  };
  Object.keys(pairs).forEach(function(k) {
    var v = pairs[k];
    var el = ensureParamInputExists(k, v);
    if (!el) return;
    if (el.tagName === "SELECT") {
      var hasOpt = Array.from(el.options).some(function(o) { return String(o.value) === String(v); });
      if (hasOpt) {
        el.value = String(v);
      } else {
        var custOpt = Array.from(el.options).find(function(o) { return o.value === "__custom__"; });
        if (custOpt) {
          el.value = "__custom__";
          var cInp = document.querySelector('[data-custom-for="' + k + '"]');
          if (cInp) cInp.value = String(v);
        }
      }
    } else {
      el.value = String(v);
    }
  });
}

function onLidTextInput(field, val) {
  lidState[field] = val;
  if (lidState.mode === "none" && val.trim().length > 0) {
    lidState.mode = "debossed";
    var mSel = document.getElementById("lid-quick-mode");
    if (mSel) mSel.value = "debossed";
  }
  pushLidStateToDOM();
  drawLidLabelPreviewCanvas();
  // Debounce 3D OpenSCAD compilation to 650ms after typing stops so we NEVER spam /api/render!
  var autoChk = document.getElementById("auto-render");
  if (autoChk && autoChk.checked && typeof renderPart === "function") {
    clearTimeout(window.renderTimeout);
    window.renderTimeout = setTimeout(function() { renderPart(); }, 650);
  }
}

function updateLidColor(which, hexVal) {
  lidPreviewColors[which] = hexVal;
  drawLidLabelPreviewCanvas();
  applyLiveColorsTo3DScene();
}

function setLidControlFromPreview(key, val) {
  lidState[key] = val;
  pushLidStateToDOM();
  drawLidLabelPreviewCanvas();
  renderMultiColor3DOverlays();
  triggerDebouncedLidRender();
}

function resetLidLabelLayout() {
  lidState.textX = 0.0;
  lidState.textY = 0.0;
  lidState.marginX = 8.0;
  lidState.marginY = 8.0;
  lidState.size = 10.0;
  if (lidState.mode === "none") lidState.mode = "debossed";
  var sl = document.getElementById("lid-font-size-slider");
  var lbl = document.getElementById("lid-font-size-lbl");
  if (sl) sl.value = "10";
  if (lbl) lbl.textContent = "10.0mm";
  pushLidStateToDOM();
  drawLidLabelPreviewCanvas();
  renderMultiColor3DOverlays();
  triggerDebouncedLidRender();
}

function triggerDebouncedLidRender() {
  pushLidStateToDOM();
  var autoChk = document.getElementById("auto-render");
  if (autoChk && autoChk.checked && typeof renderPart === "function") {
    clearTimeout(window.renderTimeout);
    window.renderTimeout = setTimeout(function() { renderPart(); }, 340);
  }
}

function drawLidLabelPreviewCanvas() {
  var cvs = document.getElementById("lid-label-canvas");
  if (!cvs) return;
  var ctx = cvs.getContext("2d");
  var W = cvs.width, H = cvs.height;
  ctx.clearRect(0, 0, W, H);

  var vals = (typeof collectParams === "function") ? collectParams() : {};
  var boxW = Math.max(30, parseFloat(vals.outer_width) || 100);
  var boxD = Math.max(30, parseFloat(vals.outer_depth) || 70);
  var cornerR = Math.max(1, parseFloat(vals.corner_radius) || 4);

  var mode = lidState.mode || "multicolor_inlay";
  var t1 = String(lidState.line1 !== undefined ? lidState.line1 : "M5 HARDWARE").trim();
  var t2 = String(lidState.line2 !== undefined ? lidState.line2 : "").trim();
  var fontRaw = lidState.font || "Liberation Sans:style=Bold";
  var textMM = Math.max(4, Math.min(28, parseFloat(lidState.size) || 10));
  var frameStyle = lidState.frame || "rounded_box";
  var textX = parseFloat(lidState.textX) || 0;
  var textY = parseFloat(lidState.textY) || 0;
  var marginX = Math.max(3, parseFloat(lidState.marginX) || 8.0);
  var marginY = Math.max(3, parseFloat(lidState.marginY) || 8.0);

  var scale = Math.min((W - 28) / boxW, (H - 22) / boxD);
  var drawW = boxW * scale;
  var drawD = boxD * scale;
  var ox = (W - drawW) / 2;
  var oy = (H - drawD) / 2 - 2;
  var radPx = Math.min(drawW * 0.25, cornerR * scale);

  lidHitBoxes.scale = scale;
  lidHitBoxes.ox = ox;
  lidHitBoxes.oy = oy;
  lidHitBoxes.drawW = drawW;
  lidHitBoxes.drawD = drawD;
  lidHitBoxes.boxW = boxW;
  lidHitBoxes.boxD = boxD;

  ctx.save();
  drawSafeRoundRect(ctx, ox, oy, drawW, drawD, radPx);
  ctx.fillStyle = lidPreviewColors.box || "#1e293b";
  ctx.fill();
  ctx.lineWidth = 2;
  ctx.strokeStyle = "#64748b";
  ctx.stroke();
  ctx.clip();

  // Ghost Cubby Grid
  var totalCubbyX = boxLayoutState.colWidths.reduce(function(a, b) { return a + b; }, 0) || 1;
  var wallPx = (parseFloat(vals.wall_thick) || 2.4) * scale;
  var inOx = ox + wallPx;
  var inOy = oy + wallPx;
  var inW  = Math.max(10, drawW - wallPx * 2);
  var inD  = Math.max(10, drawD - wallPx * 2);

  ctx.save();
  ctx.strokeStyle = "rgba(255, 255, 255, 0.16)";
  ctx.setLineDash([3, 3]);
  ctx.lineWidth = 1.2;
  var curX = inOx;
  for (var c = 0; c < boxLayoutState.colWidths.length; c++) {
    var cw = boxLayoutState.colWidths[c];
    var pixW = (cw / totalCubbyX) * inW;
    var rList = boxLayoutState.colRows[c] || [1];
    var totalCubbyY = rList.reduce(function(a, b) { return a + b; }, 0) || 1;
    var curY = inOy;
    for (var r = 0; r < rList.length - 1; r++) {
      curY += (rList[r] / totalCubbyY) * inD;
      ctx.beginPath();
      ctx.moveTo(curX + 2, curY);
      ctx.lineTo(curX + pixW - 2, curY);
      ctx.stroke();
    }
    curX += pixW;
    if (c < boxLayoutState.colWidths.length - 1) {
      ctx.beginPath();
      ctx.moveTo(curX, inOy + 2);
      ctx.lineTo(curX, inOy + inD - 2);
      ctx.stroke();
    }
  }
  ctx.restore();

  if (mode === "none") {
    ctx.restore();
    ctx.fillStyle = "rgba(226, 232, 240, 0.9)";
    ctx.font = "600 11px system-ui, sans-serif";
    ctx.textAlign = "center";
    ctx.textBaseline = "middle";
    ctx.fillText("Plain Lid (Click to Enable Multi-Color Wording & Frame)", W / 2, H / 2 - 2);
    cvs.onclick = function() { setLidControlFromPreview("mode", "debossed"); };
    return;
  }
  cvs.onclick = null;

  var fColor = "#f59e0b";
  var tColor = "#38bdf8";

  var fwMM = Math.max(14, boxW - marginX * 2);
  var fdMM = Math.max(12, boxD - marginY * 2);
  var fw = fwMM * scale;
  var fd = fdMM * scale;
  var fx = ox + (drawW - fw) / 2;
  var fy = oy + (drawD - fd) / 2;
  var fThick = Math.max(1.8, 2.0 * scale);

  if (frameStyle !== "none") {
    ctx.strokeStyle = fColor;
    ctx.lineWidth = fThick;

    if (frameStyle === "rounded_box") {
      drawSafeRoundRect(ctx, fx, fy, fw, fd, Math.max(3, 3.5 * scale));
      ctx.stroke();
    } else if (frameStyle === "chamfer_tag") {
      var ch = Math.min(fw * 0.2, 6 * scale);
      ctx.beginPath();
      ctx.moveTo(fx + ch, fy);
      ctx.lineTo(fx + fw - ch, fy);
      ctx.lineTo(fx + fw, fy + ch);
      ctx.lineTo(fx + fw, fy + fd - ch);
      ctx.lineTo(fx + fw - ch, fy + fd);
      ctx.lineTo(fx + ch, fy + fd);
      ctx.lineTo(fx, fy + fd - ch);
      ctx.lineTo(fx, fy + ch);
      ctx.closePath();
      ctx.stroke();
    } else if (frameStyle === "double_line") {
      ctx.lineWidth = Math.max(1.4, 1.2 * scale);
      drawSafeRoundRect(ctx, fx, fy, fw, fd, Math.max(2, 3.0 * scale));
      ctx.stroke();
      var inOff = 3.2 * scale;
      if (fw > inOff * 2 + 4 && fd > inOff * 2 + 4) {
        drawSafeRoundRect(ctx, fx + inOff, fy + inOff, fw - inOff * 2, fd - inOff * 2, Math.max(1.5, 1.5 * scale));
        ctx.stroke();
      }
    } else if (frameStyle === "corner_brackets") {
      var cLenX = fw * 0.22;
      var cLenY = fd * 0.26;
      [[-1, -1], [1, -1], [1, 1], [-1, 1]].forEach(function(pair) {
        var sx = pair[0], sy = pair[1];
        var cx = ox + drawW / 2 + sx * (fw / 2);
        var cy = oy + drawD / 2 + sy * (fd / 2);
        ctx.beginPath();
        ctx.moveTo(cx - sx * cLenX, cy);
        ctx.lineTo(cx, cy);
        ctx.lineTo(cx, cy - sy * cLenY);
        ctx.stroke();
      });
    }

    var rHx = fx + fw, rHy = oy + drawD / 2;
    var bHx = ox + drawW / 2, bHy = fy + fd;
    lidHitBoxes.frameRightHandle = { x: rHx, y: rHy, r: 8 };
    lidHitBoxes.frameBottomHandle = { x: bHx, y: bHy, r: 8 };
  } else {
    lidHitBoxes.frameRightHandle = null;
    lidHitBoxes.frameBottomHandle = null;
  }

  var cssFont = "system-ui, -apple-system, sans-serif";
  if (fontRaw.indexOf("Mono") !== -1) cssFont = "'Liberation Mono', 'Courier New', monospace";
  else if (fontRaw.indexOf("Serif") !== -1) cssFont = "'Liberation Serif', Georgia, serif";
  else if (fontRaw.indexOf("DejaVu") !== -1) cssFont = "'DejaVu Sans', Arial Black, sans-serif";

  var pxSize1 = Math.max(8, Math.min(48, textMM * scale * 1.0));
  var pxSize2 = Math.max(6, pxSize1 * 0.68);

  var txCenter = (ox + drawW / 2) + (textX * scale);
  var tyCenter = (oy + drawD / 2) - (textY * scale);

  ctx.fillStyle = tColor;
  ctx.textAlign = "center";
  ctx.textBaseline = "middle";

  var boxHalfW = 28, boxHalfH = pxSize1 * 0.65;

  if (t1 && t2) {
    ctx.font = "800 " + pxSize1.toFixed(1) + "px " + cssFont;
    var w1 = ctx.measureText(t1).width;
    ctx.fillText(t1, txCenter, tyCenter - pxSize1 * 0.52);

    ctx.font = "700 " + pxSize2.toFixed(1) + "px " + cssFont;
    var w2 = ctx.measureText(t2).width;
    ctx.fillText(t2, txCenter, tyCenter + pxSize1 * 0.62);

    boxHalfW = Math.max(18, Math.max(w1, w2) / 2 + 6);
    boxHalfH = pxSize1 * 1.15;
  } else if (t1) {
    ctx.font = "800 " + pxSize1.toFixed(1) + "px " + cssFont;
    var w1s = ctx.measureText(t1).width;
    ctx.fillText(t1, txCenter, tyCenter);
    boxHalfW = Math.max(18, w1s / 2 + 6);
    boxHalfH = pxSize1 * 0.68;
  } else if (t2) {
    ctx.font = "700 " + (pxSize1 * 0.75).toFixed(1) + "px " + cssFont;
    var w2s = ctx.measureText(t2).width;
    ctx.fillText(t2, txCenter, tyCenter);
    boxHalfW = Math.max(18, w2s / 2 + 6);
    boxHalfH = pxSize1 * 0.55;
  }

  ctx.restore();

  if (frameStyle !== "none" && lidHitBoxes.frameRightHandle && lidHitBoxes.frameBottomHandle) {
    var rH = lidHitBoxes.frameRightHandle;
    var bH = lidHitBoxes.frameBottomHandle;
    ctx.fillStyle = "#f59e0b";
    ctx.strokeStyle = "#0f172a";
    ctx.lineWidth = 1.5;
    ctx.fillRect(rH.x - 4, rH.y - 4, 8, 8);
    ctx.strokeRect(rH.x - 4, rH.y - 4, 8, 8);
    ctx.fillRect(bH.x - 4, bH.y - 4, 8, 8);
    ctx.strokeRect(bH.x - 4, bH.y - 4, 8, 8);
  }

  if (t1 || t2) {
    var bx = txCenter - boxHalfW;
    var by = tyCenter - boxHalfH;
    var bw = boxHalfW * 2;
    var bh = boxHalfH * 2;

    ctx.save();
    ctx.strokeStyle = "rgba(56, 189, 248, 0.7)";
    ctx.setLineDash([2, 2]);
    ctx.lineWidth = 1.2;
    ctx.strokeRect(bx, by, bw, bh);
    ctx.restore();

    var hx = bx + bw;
    var hy = by + bh;
    ctx.fillStyle = "#38bdf8";
    ctx.strokeStyle = "#0f172a";
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    ctx.arc(hx, hy, 5, 0, Math.PI * 2);
    ctx.fill();
    ctx.stroke();

    lidHitBoxes.textRect = { x: bx, y: by, w: bw, h: bh };
    lidHitBoxes.textHandle = { x: hx, y: hy, r: 10 };
  }

  ctx.fillStyle = "rgba(148, 163, 184, 0.9)";
  ctx.font = "600 9px system-ui, sans-serif";
  ctx.textAlign = "left";
  ctx.fillText("Size: " + textMM.toFixed(1) + "mm | Pos: (" + textX.toFixed(1) + ", " + textY.toFixed(1) + ")mm | Margin: " + marginX.toFixed(1) + "×" + marginY.toFixed(1) + "mm", 8, H - 5);

  pushLidStateToDOM();
  bindLidCanvasDragEvents();
}

function bindLidCanvasDragEvents() {
  var cvs = document.getElementById("lid-label-canvas");
  if (!cvs || cvs.dataset.dragBound === "1") return;
  cvs.dataset.dragBound = "1";

  cvs.addEventListener("mousedown", function(e) {
    if (lidState.mode === "none") return;
    var rect = cvs.getBoundingClientRect();
    var mx = (e.clientX - rect.left) * (cvs.width / rect.width);
    var my = (e.clientY - rect.top) * (cvs.height / rect.height);

    if (lidHitBoxes.textHandle && Math.hypot(mx - lidHitBoxes.textHandle.x, my - lidHitBoxes.textHandle.y) <= 10) {
      lidDragState = { type: "scale_text", startY: my, startX: mx, startSize: lidState.size };
      e.preventDefault();
      return;
    }
    if (lidHitBoxes.frameRightHandle && Math.hypot(mx - lidHitBoxes.frameRightHandle.x, my - lidHitBoxes.frameRightHandle.y) <= 10) {
      lidDragState = { type: "frame_x", startX: mx, startMarginX: lidState.marginX };
      e.preventDefault();
      return;
    }
    if (lidHitBoxes.frameBottomHandle && Math.hypot(mx - lidHitBoxes.frameBottomHandle.x, my - lidHitBoxes.frameBottomHandle.y) <= 10) {
      lidDragState = { type: "frame_y", startY: my, startMarginY: lidState.marginY };
      e.preventDefault();
      return;
    }
    var tr = lidHitBoxes.textRect;
    if (tr && mx >= tr.x && mx <= tr.x + tr.w && my >= tr.y && my <= tr.y + tr.h) {
      lidDragState = { type: "move_text", startX: mx, startY: my, origX: lidState.textX, origY: lidState.textY };
      e.preventDefault();
      return;
    }
  });
}

window.addEventListener("mousemove", function(e) {
  var cvsEl = document.getElementById("lid-label-canvas");
  if (!cvsEl) return;
  var rect = cvsEl.getBoundingClientRect();
  var mx = (e.clientX - rect.left) * (cvsEl.width / rect.width);
  var my = (e.clientY - rect.top) * (cvsEl.height / rect.height);

  if (!lidDragState) {
    if (lidHitBoxes.textHandle && Math.hypot(mx - lidHitBoxes.textHandle.x, my - lidHitBoxes.textHandle.y) <= 10) {
      cvsEl.style.cursor = "nwse-resize";
    } else if (lidHitBoxes.frameRightHandle && Math.hypot(mx - lidHitBoxes.frameRightHandle.x, my - lidHitBoxes.frameRightHandle.y) <= 10) {
      cvsEl.style.cursor = "ew-resize";
    } else if (lidHitBoxes.frameBottomHandle && Math.hypot(mx - lidHitBoxes.frameBottomHandle.x, my - lidHitBoxes.frameBottomHandle.y) <= 10) {
      cvsEl.style.cursor = "ns-resize";
    } else if (lidHitBoxes.textRect && mx >= lidHitBoxes.textRect.x && mx <= lidHitBoxes.textRect.x + lidHitBoxes.textRect.w && my >= lidHitBoxes.textRect.y && my <= lidHitBoxes.textRect.y + lidHitBoxes.textRect.h) {
      cvsEl.style.cursor = "move";
    } else {
      cvsEl.style.cursor = "default";
    }
    return;
  }

  var sc = lidHitBoxes.scale || 1;
  if (lidDragState.type === "move_text") {
    var dxMM = (mx - lidDragState.startX) / sc;
    var dyMM = -(my - lidDragState.startY) / sc;
    var maxX = lidHitBoxes.boxW * 0.42;
    var maxY = lidHitBoxes.boxD * 0.42;
    lidState.textX = Math.max(-maxX, Math.min(maxX, +(lidDragState.origX + dxMM).toFixed(1)));
    lidState.textY = Math.max(-maxY, Math.min(maxY, +(lidDragState.origY + dyMM).toFixed(1)));
    drawLidLabelPreviewCanvas();
  } else if (lidDragState.type === "scale_text") {
    var deltaPx = (mx - lidDragState.startX) + (my - lidDragState.startY);
    lidState.size = Math.max(4.0, Math.min(26.0, +(lidDragState.startSize + deltaPx / (sc * 2.2)).toFixed(1)));
    var sl = document.getElementById("lid-font-size-slider");
    var lbl = document.getElementById("lid-font-size-lbl");
    if (sl) sl.value = String(lidState.size);
    if (lbl) lbl.textContent = lidState.size.toFixed(1) + "mm";
    drawLidLabelPreviewCanvas();
  } else if (lidDragState.type === "frame_x") {
    var dxMM2 = (mx - lidDragState.startX) / sc;
    lidState.marginX = Math.max(3.0, Math.min(lidHitBoxes.boxW * 0.38, +(lidDragState.startMarginX - dxMM2).toFixed(1)));
    drawLidLabelPreviewCanvas();
  } else if (lidDragState.type === "frame_y") {
    var dyMM2 = (my - lidDragState.startY) / sc;
    lidState.marginY = Math.max(3.0, Math.min(lidHitBoxes.boxD * 0.38, +(lidDragState.startMarginY - dyMM2).toFixed(1)));
    drawLidLabelPreviewCanvas();
  }
});

window.addEventListener("mouseup", function() {
  if (lidDragState) {
    lidDragState = null;
    triggerDebouncedLidRender();
  }
});

// ============================================================================
// OTHER 8 CATEGORY 2D SCHEMATICS
// ============================================================================
function renderFastener2D(card, vals) {
  card.style.display = "block";
  var pType = vals.part_type || "bolt";
  var spec = (vals.unit_system === "imperial") ? (vals.imperial_size || "1/4-20") : (vals.metric_size || "M8");
  var cov = vals.thread_coverage || "partial_grip";
  var gripL = parseFloat(vals.shoulder_grip_len) || 21;
  var totalL = parseFloat(vals.length) || 25;
  var slop = parseFloat(vals.printer_slop) || 0.12;

  card.innerHTML = '<div style="margin-bottom:5px; color:#60a5fa;"><strong>📐 2D Fastener Profile & Grip Schematic (' + spec + ' ' + pType.toUpperCase() + ')</strong></div>' +
    '<canvas id="fastener-canvas" width="376" height="115" style="width:100%; height:115px; background:#0f172a; border:1px solid #3b82f6; border-radius:6px; display:block; margin-bottom:7px;"></canvas>' +
    (pType === "bolt" && cov === "partial_grip" ?
      '<div style="display:flex; align-items:center; gap:6px; margin-bottom:4px;"><span style="font-size:0.72rem; color:#93c5fd; width:115px;">Unthreaded Grip: <strong>' + gripL + 'mm</strong></span><input type="range" min="4" max="80" step="0.5" value="' + gripL + '" style="flex:1; accent-color:#3b82f6;" oninput="setParamFromVisual(\'shoulder_grip_len\', this.value)"></div>' :
      (pType === "bolt" || pType === "rod") ?
      '<div style="display:flex; align-items:center; gap:6px; margin-bottom:4px;"><span style="font-size:0.72rem; color:#93c5fd; width:115px;">Total Length: <strong>' + totalL + 'mm</strong></span><input type="range" min="6" max="120" step="1" value="' + totalL + '" style="flex:1; accent-color:#3b82f6;" oninput="setParamFromVisual(\'length\', this.value)"></div>' : ''
    ) +
    '<div style="display:flex; align-items:center; gap:6px;"><span style="font-size:0.72rem; color:#6ee7b7; width:115px;">Fit Slop: <strong>' + slop + 'mm</strong></span><input type="range" min="0.08" max="0.25" step="0.02" value="' + slop + '" style="flex:1; accent-color:#10b981;" oninput="setParamFromVisual(\'printer_slop\', this.value)"></div>';

  var cvs = document.getElementById("fastener-canvas");
  if (!cvs) return;
  var ctx = cvs.getContext("2d");
  ctx.clearRect(0, 0, cvs.width, cvs.height);
  var cy = cvs.height / 2;
  if (pType === "bolt") {
    var headW = 34, headH = 44;
    var shL = (cov === "partial_grip") ? Math.min(170, gripL * 4.5) : (cov === "full" ? 0 : 90);
    var thL = (cov === "partial_grip") ? 55 : (cov === "full" ? 180 : 80);
    ctx.fillStyle = "#334155"; ctx.strokeStyle = "#94a3b8"; ctx.lineWidth = 2;
    ctx.fillRect(22, cy - headH/2, headW, headH); ctx.strokeRect(22, cy - headH/2, headW, headH);
    if (shL > 0) {
      ctx.fillStyle = "rgba(59, 130, 246, 0.35)"; ctx.strokeStyle = "#60a5fa";
      ctx.fillRect(22 + headW, cy - 13, shL, 26); ctx.strokeRect(22 + headW, cy - 13, shL, 26);
      ctx.fillStyle = "#f59e0b"; ctx.fillRect(22 + headW + shL - 4, cy - 16, 4, 32);
    }
    var tx0 = 22 + headW + shL;
    ctx.fillStyle = "rgba(16, 185, 129, 0.3)"; ctx.strokeStyle = "#10b981";
    ctx.fillRect(tx0, cy - 12, thL, 24); ctx.strokeRect(tx0, cy - 12, thL, 24);
  }
}

function renderSpacer2D(card, vals) {
  card.style.display = "block";
  var L = parseFloat(vals.body_length) || 15;
  var od = parseFloat(vals.outer_diam) || 10;
  card.innerHTML = '<div style="margin-bottom:5px; color:#60a5fa;"><strong>📐 2D Spacer / Standoff (' + L + 'mm Long × ' + od + 'mm OD)</strong></div>' +
    '<div style="display:flex; gap:8px;">' +
    '<div style="flex:1;"><span style="font-size:0.7rem; color:#93c5fd;">Length: <strong>' + L + ' mm</strong></span><input type="range" min="2" max="60" step="0.5" value="' + L + '" style="width:100%; accent-color:#3b82f6;" oninput="setParamFromVisual(\'body_length\', this.value)"></div>' +
    '<div style="flex:1;"><span style="font-size:0.7rem; color:#6ee7b7;">Outer OD: <strong>' + od + ' mm</strong></span><input type="range" min="4" max="30" step="0.5" value="' + od + '" style="width:100%; accent-color:#10b981;" oninput="setParamFromVisual(\'outer_diam\', this.value)"></div>' +
    '</div>';
}

function renderClamp2D(card, vals) {
  card.style.display = "block";
  var shape = vals.profile_shape || "round";
  var D = (shape === "square") ? (parseFloat(vals.square_width) || 25.4) : (parseFloat(vals.round_od) || 25.4);
  var W = parseFloat(vals.band_width) || 14;
  var paramKey = (shape === "square") ? "square_width" : "round_od";
  card.innerHTML = '<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:5px;"><strong style="color:#60a5fa;">📐 2D Clamp Profile (' + shape.toUpperCase() + ': ' + D + ' mm)</strong></div>' +
    '<div style="display:flex; gap:8px;">' +
    '<div style="flex:1;"><span style="font-size:0.7rem; color:#93c5fd;">Size: <strong>' + D + ' mm</strong></span><input type="range" min="6" max="75" step="0.5" value="' + D + '" style="width:100%; accent-color:#3b82f6;" oninput="setParamFromVisual(\'' + paramKey + '\', this.value)"></div>' +
    '<div style="flex:1;"><span style="font-size:0.7rem; color:#6ee7b7;">Band Width: <strong>' + W + ' mm</strong></span><input type="range" min="8" max="35" step="1" value="' + W + '" style="width:100%; accent-color:#10b981;" oninput="setParamFromVisual(\'band_width\', this.value)"></div>' +
    '</div>';
}

function renderBracket2D(card, vals) {
  card.style.display = "block";
  var L1 = parseFloat(vals.arm_x) || 50;
  var L2 = parseFloat(vals.arm_y) || 50;
  var W  = parseFloat(vals.width) || 25;
  card.innerHTML = '<div style="margin-bottom:6px;"><strong style="color:#60a5fa;">📐 2D Bracket Schematic (' + L1 + '×' + L2 + '×' + W + ' mm)</strong></div>' +
    '<div style="display:flex; gap:6px;">' +
    '<div style="flex:1;"><span style="font-size:0.7rem; color:#93c5fd;">Arm 1: <strong>' + L1 + 'mm</strong></span><input type="range" min="20" max="140" step="1" value="' + L1 + '" style="width:100%; accent-color:#3b82f6;" oninput="setParamFromVisual(\'arm_x\', this.value)"></div>' +
    '<div style="flex:1;"><span style="font-size:0.7rem; color:#6ee7b7;">Arm 2: <strong>' + L2 + 'mm</strong></span><input type="range" min="20" max="140" step="1" value="' + L2 + '" style="width:100%; accent-color:#10b981;" oninput="setParamFromVisual(\'arm_y\', this.value)"></div>' +
    '<div style="flex:1;"><span style="font-size:0.7rem; color:#fcd34d;">Width: <strong>' + W + 'mm</strong></span><input type="range" min="12" max="70" step="1" value="' + W + '" style="width:100%; accent-color:#f59e0b;" oninput="setParamFromVisual(\'width\', this.value)"></div>' +
    '</div>';
}

function renderKnob2D(card, vals) {
  card.style.display = "block";
  var OD = parseFloat(vals.outer_size) || 40;
  var lobes = parseInt(vals.lobes) || 5;
  card.innerHTML = '<div style="margin-bottom:5px; color:#60a5fa;"><strong>📐 2D Knob Blueprint (' + OD + ' mm OD)</strong></div>' +
    '<div style="display:flex; gap:8px;">' +
    '<div style="flex:1;"><span style="font-size:0.7rem; color:#93c5fd;">Diameter: <strong>' + OD + ' mm</strong></span><input type="range" min="20" max="100" step="1" value="' + OD + '" style="width:100%; accent-color:#3b82f6;" oninput="setParamFromVisual(\'outer_size\', this.value)"></div>' +
    '<div style="flex:1;"><span style="font-size:0.7rem; color:#6ee7b7;">Lobes: <strong>' + lobes + '</strong></span><input type="range" min="3" max="8" step="1" value="' + lobes + '" style="width:100%; accent-color:#10b981;" oninput="setParamFromVisual(\'lobes\', this.value)"></div>' +
    '</div>';
}

function renderEnclosure2D(card, vals) {
  card.style.display = "block";
  var IX = parseFloat(vals.inner_x) || 92;
  var IY = parseFloat(vals.inner_y) || 62;
  var IZ = parseFloat(vals.inner_z) || 30;
  card.innerHTML = '<div style="margin-bottom:5px; color:#60a5fa;"><strong>📐 2D Enclosure Floorplan (' + IX + ' × ' + IY + ' × ' + IZ + ' mm)</strong></div>' +
    '<div style="display:flex; gap:6px;">' +
    '<div style="flex:1;"><span style="font-size:0.7rem; color:#93c5fd;">Inner X: <strong>' + IX + 'mm</strong></span><input type="range" min="35" max="180" step="1" value="' + IX + '" style="width:100%; accent-color:#3b82f6;" oninput="setParamFromVisual(\'inner_x\', this.value)"></div>' +
    '<div style="flex:1;"><span style="font-size:0.7rem; color:#6ee7b7;">Inner Y: <strong>' + IY + 'mm</strong></span><input type="range" min="25" max="140" step="1" value="' + IY + '" style="width:100%; accent-color:#10b981;" oninput="setParamFromVisual(\'inner_y\', this.value)"></div>' +
    '<div style="flex:1;"><span style="font-size:0.7rem; color:#fcd34d;">Height Z: <strong>' + IZ + 'mm</strong></span><input type="range" min="15" max="80" step="1" value="' + IZ + '" style="width:100%; accent-color:#f59e0b;" oninput="setParamFromVisual(\'inner_z\', this.value)"></div>' +
    '</div>';
}

function renderGauge2D(card, vals) {
  card.style.display = "block";
  card.innerHTML = '<div style="color:#60a5fa;"><strong>📏 Fit Slop Calibration Guide: .08 = Press Fit | .12 = Threads/Tools | .16+ = Free Slide</strong></div>';
}

function renderGasket2D(card, vals) {
  card.style.display = "block";
  var ID = parseFloat(vals.inner_x) || 38.1;
  var RW = parseFloat(vals.rim_width) || 15;
  var T  = parseFloat(vals.thickness) || 2.0;
  card.innerHTML = '<div style="margin-bottom:5px; color:#60a5fa;"><strong>📐 2D Gasket Blueprint (ID: ' + ID + 'mm | Rim: ' + RW + 'mm | Thick: ' + T + 'mm)</strong></div>' +
    '<div style="display:flex; gap:6px;">' +
    '<div style="flex:1;"><span style="font-size:0.7rem; color:#93c5fd;">Inner ID: <strong>' + ID + 'mm</strong></span><input type="range" min="8" max="120" step="0.5" value="' + ID + '" style="width:100%; accent-color:#3b82f6;" oninput="setParamFromVisual(\'inner_x\', this.value)"></div>' +
    '<div style="flex:1;"><span style="font-size:0.7rem; color:#6ee7b7;">Rim: <strong>' + RW + 'mm</strong></span><input type="range" min="3" max="30" step="0.5" value="' + RW + '" style="width:100%; accent-color:#10b981;" oninput="setParamFromVisual(\'rim_width\', this.value)"></div>' +
    '<div style="flex:1;"><span style="font-size:0.7rem; color:#fcd34d;">Thick: <strong>' + T + 'mm</strong></span><input type="range" min="0.8" max="6" step="0.2" value="' + T + '" style="width:100%; accent-color:#f59e0b;" oninput="setParamFromVisual(\'thickness\', this.value)"></div>' +
    '</div>';
}

// ============================================================================
// 3D OVERLAY DISABLED (PURE ENGRAVED CUTOUT IN OPENSCAD MESH)
function findMainStlMeshInScene() { return null; }
function clearMultiColor3DOverlays() {}
function applyLiveColorsTo3DScene() {}
function renderMultiColor3DOverlays() {}
// CATEGORY-FILTERED FULL-STATE PRESET SAVE & RESTORE ENGINE
// ============================================================================
var allPresetsCache = {};

async function loadPresets() {
  try {
    var res = await fetch("/api/presets");
    allPresetsCache = await res.json();
    refreshPresetDropdownForCurrentCategory();
  } catch (e) {
    console.error("Failed to load presets:", e);
  }
}

function refreshPresetDropdownForCurrentCategory() {
  var sel = document.getElementById("preset-select");
  if (!sel) return;
  var curGen = getActiveGeneratorFilename();
  var catLabel = curGen ? curGen.replace(/^\d+_/, "").replace(".scad", "").replace(/_/g, " ") : "current category";

  var matchingKeys = Object.keys(allPresetsCache).filter(function(name) {
    var p = allPresetsCache[name];
    return p && p.generator === curGen;
  });

  sel.innerHTML = '<option value="">-- Saved in ' + catLabel.toUpperCase() + ' (' + matchingKeys.length + ') --</option>';
  matchingKeys.sort().forEach(function(name) {
    var opt = document.createElement("option");
    opt.value = name;
    opt.textContent = "⭐ " + name;
    sel.appendChild(opt);
  });
}

window.savePreset = async function() {
  if (!currentGenerator) return;
  if (currentGenerator.filename === "06_boxes_organizers.scad") {
    syncLayoutSpecToInput(false);
    pushLidStateToDOM();
  }
  var defaultName = currentGenerator.name + " - Custom";
  var name = prompt("Enter a name to save this " + currentGenerator.name + " preset:", defaultName);
  if (!name || !name.trim()) return;

  var fullParams = collectParams();
  var uiState = {
    boxLayoutState: JSON.parse(JSON.stringify(boxLayoutState)),
    lidState: JSON.parse(JSON.stringify(lidState)),
    lidPreviewColors: JSON.parse(JSON.stringify(lidPreviewColors))
  };

  await fetch("/api/presets", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      name: name.trim(),
      generator: currentGenerator.filename,
      params: fullParams,
      ui_state: uiState
    })
  });

  await loadPresets();
  var sel = document.getElementById("preset-select");
  if (sel) sel.value = name.trim();
};

window.applyPreset = async function() {
  var sel = document.getElementById("preset-select");
  if (!sel || !sel.value) return;
  var presetName = sel.value;
  var p = allPresetsCache[presetName];
  if (!p) return;

  var genSel = document.getElementById("generator-select");
  if (genSel && getActiveGeneratorFilename() !== p.generator && typeof generators !== "undefined") {
    var gIdx = generators.findIndex(function(g) { return g.filename === p.generator; });
    if (gIdx !== -1) {
      var matchOpt = Array.from(genSel.options).find(function(o) { return o.value === p.generator || o.value === String(gIdx); });
      if (matchOpt) genSel.value = matchOpt.value;
      currentGenerator = generators[gIdx];
      if (typeof buildControls === "function") buildControls(currentGenerator);
    }
  }

  var savedParams = p.params || {};
  Object.keys(savedParams).forEach(function(k) {
    var val = savedParams[k];
    var el = document.querySelector('[data-param="' + k + '"]');
    if (!el) el = ensureParamInputExists(k, val);
    if (!el) return;

    if (el.tagName === "SELECT") {
      var matchOpt = Array.from(el.options).find(function(o) { return String(o.value) === String(val); });
      if (matchOpt) {
        el.value = String(val);
        var custWrap = document.getElementById("custom-wrap-" + k);
        if (custWrap) custWrap.style.display = "none";
      } else {
        var custOpt = Array.from(el.options).find(function(o) { return o.value === "__custom__"; });
        if (custOpt) {
          el.value = "__custom__";
          var custWrap2 = document.getElementById("custom-wrap-" + k);
          if (custWrap2) custWrap2.style.display = "flex";
          var custInp = document.querySelector('[data-custom-for="' + k + '"]');
          if (custInp) {
            custInp.value = String(val);
            var unitSel = document.querySelector('[data-unit-for="' + k + '"]');
            if (unitSel) unitSel.value = "mm";
          }
        }
      }
    } else if (el.type === "checkbox") {
      el.checked = Boolean(val);
    } else {
      el.value = String(val);
    }
  });

  if (p.ui_state) {
    if (p.ui_state.boxLayoutState) Object.assign(boxLayoutState, JSON.parse(JSON.stringify(p.ui_state.boxLayoutState)));
    if (p.ui_state.lidState) Object.assign(lidState, JSON.parse(JSON.stringify(p.ui_state.lidState)));
    if (p.ui_state.lidPreviewColors) Object.assign(lidPreviewColors, JSON.parse(JSON.stringify(p.ui_state.lidPreviewColors)));
  }

  if (typeof updateVisibility === "function") updateVisibility();
  updateMaster2DDesigner(false);
  if (currentGenerator && currentGenerator.filename === "06_boxes_organizers.scad") {
    syncLayoutSpecToInput(false);
    pushLidStateToDOM();
  }
  await renderPart();
};

window.deleteSelectedPreset = async function() {
  var sel = document.getElementById("preset-select");
  if (!sel || !sel.value) return;
  var name = sel.value;
  if (!confirm('Delete saved preset "' + name + '"?')) return;
  await fetch("/api/presets/" + encodeURIComponent(name), { method: "DELETE" });
  await loadPresets();
};

// ============================================================================
// FAILSAFE AUTO-INITIALIZER
// ============================================================================
(function attachVisualSuiteHooks() {
  function boot() {
    ensureDesignerCard();
    var genSel = document.getElementById("generator-select");
    var paramsCont = document.getElementById("params-container");
    if (genSel && !genSel.dataset.visualHooked) {
      genSel.dataset.visualHooked = "1";
      genSel.addEventListener("change", function() { setTimeout(function() { updateMaster2DDesigner(true); }, 40); });
    }
    if (paramsCont && !paramsCont.dataset.visualHooked) {
      paramsCont.dataset.visualHooked = "1";
      paramsCont.addEventListener("change", function() { setTimeout(function() { updateMaster2DDesigner(false); }, 20); });
      paramsCont.addEventListener("input", function() { setTimeout(function() { updateMaster2DDesigner(false); }, 20); });
      var obs = new MutationObserver(function(mutations) {
        var hasGroupChange = mutations.some(function(m) {
          return Array.from(m.addedNodes).some(function(n) { return n.classList && n.classList.contains("param-group"); });
        });
        if (hasGroupChange) setTimeout(function() { updateMaster2DDesigner(false); }, 40);
      });
      obs.observe(paramsCont, { childList: true });
    }

    if (typeof window.origRenderPart === "undefined" && typeof window.renderPart === "function") {
      window.origRenderPart = window.renderPart;
      window.renderPart = async function() {
        clearMultiColor3DOverlays();
        if (getActiveGeneratorFilename() === "06_boxes_organizers.scad") {
          hideRedundantLidSidebarControls();
          syncLayoutSpecToInput(false);
          pushLidStateToDOM();
        }
        var res = await window.origRenderPart();
        if (getActiveGeneratorFilename() === "06_boxes_organizers.scad") {
          setTimeout(function() { renderMultiColor3DOverlays(); }, 250);
        }
        return res;
      };
    }

    var pSel = document.getElementById("preset-select");
    if (pSel && pSel.parentNode && !document.getElementById("delete-preset-btn")) {
      var delBtn = document.createElement("button");
      delBtn.id = "delete-preset-btn";
      delBtn.title = "Delete selected preset";
      delBtn.textContent = "🗑️";
      delBtn.style.cssText = "width:auto; padding:6px 8px; background:#374151; color:#fca5a5; font-size:0.75rem;";
      delBtn.onclick = function() { window.deleteSelectedPreset(); };
      pSel.parentNode.appendChild(delBtn);
    }

    loadPresets();
    updateMaster2DDesigner(false);
  }
  if (document.readyState === "loading") {
    window.addEventListener("DOMContentLoaded", function() { setTimeout(boot, 180); });
  } else {
    setTimeout(boot, 180);
  }
})();


var lastPolledGen = "";
setInterval(function() {
  var fg = getActiveGeneratorFilename();
  if (!fg) return;
  var card = ensureDesignerCard();
  if (!card) return;
  if (fg !== lastPolledGen) {
    lastPolledGen = fg;
    updateMaster2DDesigner(true);
  } else if (card.style.display === "none" || card.innerHTML.trim() === "") {
    var supported = [
      "06_boxes_organizers.scad", "01_fasteners.scad", "04_spacers_standoffs.scad",
      "07_clamps_mounts.scad", "08_brackets_joinery.scad", "09_knobs_handles.scad",
      "10_enclosures_plates.scad", "11_gauges_jigs.scad", "12_gaskets_seals.scad"
    ];
    if (supported.indexOf(fg) !== -1) {
      updateMaster2DDesigner(false);
    }
  }
}, 300);

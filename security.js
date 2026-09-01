/* ============================================================
   ZNAL AI — Proteksi Dasar (Client-Side Deterrent)
   ============================================================ */
(function(){
  "use strict";
  const ALLOWED_DOMAINS = [];
  const ALLOW_LOCALHOST = true;
  const ENABLE_DEVTOOLS_SIZE_DETECTOR = false;

  function showBlockScreen(){
    document.documentElement.innerHTML =
      '<div style="height:100vh;display:flex;align-items:center;justify-content:center;' +
      'background:#07070b;color:#ff6b6b;font-family:monospace;font-size:20px;' +
      'text-align:center;padding:20px;">Eror 244 NalaNeo</div>';
  }
  function checkDomain(){
    if(!ALLOWED_DOMAINS.length) return;
    const host = location.hostname;
    if(ALLOW_LOCALHOST && (host === "localhost" || host === "127.0.0.1")) return;
    if(!ALLOWED_DOMAINS.includes(host)){ showBlockScreen(); }
  }
  function disableRightClick(){
    document.addEventListener("contextmenu", function(e){ e.preventDefault(); });
  }
  function disableShortcuts(){
    document.addEventListener("keydown", function(e){
      const k = e.key ? e.key.toLowerCase() : "";
      if(k === "f12"){ e.preventDefault(); return; }
      if(e.ctrlKey && e.shiftKey && (k === "i" || k === "j" || k === "c")){ e.preventDefault(); return; }
      if(e.ctrlKey && (k === "u" || k === "s")){ e.preventDefault(); return; }
    });
  }
  function consoleWarning(){
    console.log("%cBerhenti!", "color:#ff6b6b;font-size:26px;font-weight:900;");
    console.log("%cIni fitur browser untuk developer. Kalau ada orang yang menyuruh kamu paste sesuatu di sini, itu hampir pasti penipuan (scam) buat mencuri akunmu.", "color:#aaa8ba;font-size:13px;");
  }
  function devtoolsSizeDetector(){
    if(!ENABLE_DEVTOOLS_SIZE_DETECTOR) return;
    let triggered = false;
    const threshold = 170;
    setInterval(function(){
      const widthGap = window.outerWidth - window.innerWidth > threshold;
      const heightGap = window.outerHeight - window.innerHeight > threshold;
      if((widthGap || heightGap) && !triggered){ triggered = true; showBlockScreen(); }
    }, 1000);
  }
  checkDomain();
  disableRightClick();
  disableShortcuts();
  consoleWarning();
  devtoolsSizeDetector();
})();

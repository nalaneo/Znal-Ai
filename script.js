"use strict";

document.addEventListener("DOMContentLoaded", () => {

  const processText =
    document.getElementById("processText");

  const statusText =
    document.getElementById("statusText");

  if (!processText || !statusText) {
    return;
  }

  const states = [
    {
      process: "PROCESSING",
      status: "Memperbaiki sistem"
    },
    {
      process: "REPAIRING",
      status: "Memeriksa layanan"
    },
    {
      process: "OPTIMIZING",
      status: "Mengoptimalkan sistem"
    },
    {
      process: "SYNCING",
      status: "Sinkronisasi layanan"
    },
    {
      process: "RECOVERING",
      status: "Memulihkan sistem"
    }
  ];

  let index = 0;

  function changeStatus() {

    processText.style.opacity = "0";
    statusText.style.opacity = "0";

    setTimeout(() => {

      index++;

      if (index >= states.length) {
        index = 0;
      }

      processText.textContent =
        states[index].process;

      statusText.textContent =
        states[index].status;

      processText.style.opacity = "1";
      statusText.style.opacity = "1";

    }, 220);
  }

  setInterval(changeStatus, 2400);


  /* Smooth pointer glow */

  let mouseX = 0;
  let mouseY = 0;

  let currentX = 0;
  let currentY = 0;

  document.addEventListener("mousemove", (event) => {

    mouseX = event.clientX;
    mouseY = event.clientY;

  });

  function animateGlow() {

    currentX +=
      (mouseX - currentX) * 0.04;

    currentY +=
      (mouseY - currentY) * 0.04;

    document.documentElement.style
      .setProperty(
        "--mouse-x",
        `${currentX}px`
      );

    document.documentElement.style
      .setProperty(
        "--mouse-y",
        `${currentY}px`
      );

    requestAnimationFrame(animateGlow);
  }

  animateGlow();

});

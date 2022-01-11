document.addEventListener("click", (event) => {
  const hamburger = document.querySelector(".navbar-light-hb img");
  // const panel = document.querySelector(".panel");
  let eventTarget = event.target; // clicked target
  if (eventTarget == hamburger) {
    document.querySelector(".panel").classList.add("active");
  } else {
    document.querySelector(".panel").classList.remove("active");
  }
});

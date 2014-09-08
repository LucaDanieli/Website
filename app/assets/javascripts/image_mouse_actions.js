var image_mouse_actions;

image_mouse_actions = function() {
  document.getElementById("profile_image").onmouseover = function() {
    this.style.opacity = 1;
  };
  document.getElementById("profile_image").onmouseout = function() {
    this.style.opacity = 0.9;
  };
};

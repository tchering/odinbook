document.addEventListener("turbo:load", () => {
  const fileInput = document.querySelector('input[type="file"]');
  if (fileInput) {
    fileInput.addEventListener("change", function (e) {
      const selectedImage = document.getElementById("selected-image");
      if (e.target.files.length > 0) {
        selectedImage.classList.remove("d-none");
      }

      const closeButton = selectedImage.querySelector(".btn-close");
      if (closeButton) {
        closeButton.addEventListener("click", function () {
          e.target.value = "";
          selectedImage.classList.add("d-none");
        });
      }
    });
  }
});

//all html loaded
document.addEventListener("DOMContentLoaded", function () {
  const email = {
    email: "",
    asunto: "",
    mensaje: "",
  };

  const inputEmail = document.querySelector("#email");
  const inputSubject = document.querySelector("#asunto");
  const inputMsg = document.querySelector("#mensaje");
  const form = document.querySelector("#formulario");
  const btnSubmit = document.querySelector('#formulario button[type="submit"]');
  const btnReset = document.querySelector('#formulario button[type="reset"]');
  const spinner = document.querySelector("#spinner");

  //trigger in the field but after user click another
  //inputEmail.addEventListener("blur", validate);

  //trigger in the field but after user click another
  //inputSubject.addEventListener("blur", validate);
  //trigger in the field but after user click another
  //inputMsg.addEventListener("blur", validate);
  //realtime
  inputEmail.addEventListener("input", validate);
  inputSubject.addEventListener("input", validate);
  inputMsg.addEventListener("input", validate);

  form.addEventListener("submit", enviarEmail);

  btnReset.addEventListener("click", function (e) {
    e.preventDefault();
    //reset object
    resetForm();
  });

  function enviarEmail(e) {
    e.preventDefault();
    spinner.classList.add("flex");
    spinner.classList.remove("hidden");

    setTimeout(() => {
      spinner.classList.remove("flex");
      spinner.classList.add("hidden");
      //reset object
      resetForm();

      //create alert
      const alertSucess = document.createElement("P");
      alertSucess.classList.add(
        "bg-green-500",
        "text-white",
        "p-2",
        "text-center",
        "rounded-lg",
        "mt-10",
        "font-bold",
        "text-sm",
        "uppercase"
      );
      alertSucess.textContent = "Email sent suceesfully";
      form.appendChild(alertSucess);

      setTimeout(() => {
        alertSucess.remove();
      }, 3000);
    }, 3000);
  }

  function validate(e) {
    console.log(e.target.parentElement);
    //e.target.parentElement.nextElementSibling
    console.log(e.target.id);
    if (e.target.value.trim() === "") {
      showAlert(`Field ${e.target.id} is obligatory`, e.target.parentElement);
      email[e.target.name] = "";
      checkEmail();
      return;
    }

    if (e.target.id === "email" && !valEmail(e.target.value)) {
      showAlert(
        `Email: ${e.target.value} is not valid`,
        e.target.parentElement
      );
      email[e.target.name] = "";
      checkEmail();
      return;
    }
    cleanAlert(e.target.parentElement);

    //asign the values
    email[e.target.name] = e.target.value.trim().toLowerCase();
    console.log(email);
    checkEmail();
  }

  function showAlert(msg, reference) {
    cleanAlert(reference);
    //generate HTML
    const error = document.createElement("P");
    error.textContent = msg;
    error.classList.add("bg-red-600", "text-white", "text-center", "p-2");
    reference.appendChild(error);
  }

  //move the reference to know which alert
  function cleanAlert(reference) {
    //validate if there is allready alert creates use reference the parent only on the div of the field
    const alert = reference.querySelector(".bg-red-600");
    if (alert) {
      alert.remove();
    }
  }

  function valEmail(email) {
    const regex = /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/;

    const result = regex.test(email);
    console.log(result);
    return result;
  }

  function checkEmail() {
    //return array with . includes if one contain empty value return true
    console.log(Object.values(email).includes(""));
    if (Object.values(email).includes("")) {
      btnSubmit.classList.add("opacity-50");
      btnSubmit.disabled = true;
      return;
    }
    btnSubmit.classList.remove("opacity-50");
    btnSubmit.disabled = false;
  }

  function resetForm() {
    //reset object
    email.email = "";
    email.asunto = "";
    email.mensaje = "";
    form.reset();
    checkEmail();
  }
});

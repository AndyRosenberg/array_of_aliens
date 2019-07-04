import 'bootstrap';
import Amber from 'amber';


document.addEventListener("DOMContentLoaded", function(event) {
  var filepath = document.getElementById("filepath");
  filepath.addEventListener("change", function(e) {
    var file = filepath.files[0];
    var reader = new FileReader();
    var img = document.getElementById("imgbody");

    reader.addEventListener("load", function () {
      img.setAttribute('value', reader.result);
    }, false);

    if (file) {
      reader.readAsDataURL(file);
    }
  });
});

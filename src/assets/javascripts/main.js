import 'bootstrap';
import Amber from 'amber';

function encodeImageFileAsURL(element) {
  var file = element.files[0];
  var reader = new FileReader();
  var img = document.getElementById("imgbody");
  img.setAttribute('value', reader.readAsDataURL(file));
}
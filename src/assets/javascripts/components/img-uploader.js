import Vue from 'vue/dist/vue.esm.js';

Vue.component('img-uploader', {
  template: `<span>
               <input @change="getImg" type="file" id="filepath" name="filepath" />
               <input type="hidden" id="imgbody" name="imgbody" />
             </span>`,
  methods: {
    getImg: function(e) {
      var filepath = e.target;
      var file = filepath.files[0];
      var reader = new FileReader();
      var img = document.getElementById("imgbody");
  
      reader.addEventListener("load", function () {
        img.setAttribute('value', reader.result.split(",")[1]);
      }, false);
  
      if (file) {
        reader.readAsDataURL(file);
      }
    }
  }
});
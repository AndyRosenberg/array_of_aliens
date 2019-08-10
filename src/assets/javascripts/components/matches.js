import axios from 'axios';
import Vue from 'vue/dist/vue.esm.js';
import $ from 'cash-dom';

Vue.component('radio-dist', {
  props: ['dist'],
  template: `
    <span>
      <label>{{dist}}</label>
      <input @change="fetchData" name="dist" type="radio" :value="dist" />
    </span>
  `,
  methods: {
    fetchData: function() {
      axios.get('/matches', { params: { dist: dist } }).then(response => {
        $('#matchList figure').remove();
        response.data.forEach(function(match) {
          $('#matchList').append(`
            <figure>
              <h5>${match.name}</h5>
              <img src='${match.pic}' />
              <figcaption>
                <span>${match.gender}</span> ->
                <span>${match.location}</span>
              </figcaption>
            </figure>
          `);
        });
      });
    }
  }
});

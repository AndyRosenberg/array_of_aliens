import axios from 'axios';
import Vue from 'vue/dist/vue.esm.js';
import $ from 'cash-dom';

new Vue({
  el: '#matches',
  created() {
    this.fetchData();	
  },
  methods: {
    fetchData() {
      axios.get('/matches').then(response => {
        response.data.forEach(function(match) {
          $('#matches').append(`
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

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
              <p>${match.name}</p>
            `);
          });
        });
      }
  }
});
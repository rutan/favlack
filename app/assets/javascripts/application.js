// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

(function (global) {
    $('#js-name-form').on('submit', function (e) {
        e.preventDefault();
        var name = $('#js-name-input').val();
        var result = name.match(new RegExp('^@?[A-Za-z0-9_-]+'));
        if (result) {
            name = result[0];
            if (name.indexOf('@') != 0) { name = '@' + name; }
            location.href = '/' + name;
        }
    });
})(this);

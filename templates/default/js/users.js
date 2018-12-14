var icms = icms || {};

icms.users = (function ($) {

    this.onDocumentReady = function () {


    };


    this.error = function(message){
        if (message) { icms.modal.alert(message); }
        this.enableStatusInput(false);
    };

    this.delete = function(link, title){
        icms.modal.openAjax(link, {}, false, title);
    };

	return this;

}).call(icms.users || {},jQuery);

$(document).bind('drop dragover', function (e) {
    e.preventDefault();
});


$('#documentform').bind('fileuploadsubmit', function (e, data) {
    var inputs = data.context.find(':input');

    data.formData = inputs.serializeArray();
});

$(document).ready(function() {
    $('#documentform').fileupload({
        dropZone: $('#dropzone'),
        previewAsCanvas: false,
        dataType: "script",
        maxNumberOfFiles: 10,
        filesContainer: $('#filescontainer'),
        prependFiles: true,
        previewSourceFileTypes: /^image\/()$/,
        replaceFileInput:false
    });
});
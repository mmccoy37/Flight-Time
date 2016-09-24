$(document).ready(function(){
    $("#submit").click(function(){
        $.ajax({
            type: 'POST',
            url: "/result",
            data: $("#flightform").serialize(),
            success: function(result){
                $('#result-panel').html(result)
            }
        })
    })
})
$(document).ready(function(){
    $('.datepicker').datepicker({
        format: 'mm/dd/yyyy',
        startDate: '-3d'
    });
})


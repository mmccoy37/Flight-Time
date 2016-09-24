$(document).ready(function(){
    $("#submit").click(function(){
        $.ajax({
            type: 'POST',
            url: "/result",
            data: $("#flightform").serialize(),
            success: function(result){
                alert(result)
                $('#result-panel').html(result)
            }
        })
    })
})


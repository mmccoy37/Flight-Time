$(document).ready(function(){
    $("#submit").click(function(){
        $('#result-panel').html("")
        document.getElementById("spinner-div").style.visibility = "visible";

        $.ajax({
            type: 'POST',
            url: "/result",
            data: $("#flightform").serialize(),
            success: function(result){
                document.getElementById("spinner-div").style.visibility = "hidden";
                $('#result-panel').html(result)
            }
        })
    })
})

// $(document).ready(function(){
//     $('.datepicker').datepicker({
//         format: 'mm/dd/yyyy',
//         startDate: '-3d'
//     });
// })

// $(function(){
//     $('a, button').click(function() {
//         $(this).toggleClass('active');
//     });
// });

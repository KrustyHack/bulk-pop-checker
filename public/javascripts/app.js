$(document).ready(function() {
    $("#check").on("click", function(e) {
        result_area = $('[name="results"]');
        emails_area = $('[name=emails]');
        loading_area = $("#loading");

        result_area.val("");
        if (emails_area.val().length <= 0) {
            result_area.val("Merci de mettre au moins une ligne à tester");
        } else {
            loading_area.modal({
                backdrop: 'static',
                keyboard: false
            });
            $.ajax({
                url: "/check",
                type: "POST",
                data: emails_area
            }).done(function(success) {
                success.forEach(function(email) {
                    result_area.val(result_area.val() + email + "\n");
                });
                loading_area.modal("hide");
            }).fail(function(error) {
                console.log(error);
                result_area.val("Une erreur est survenue");
                loading_area.modal("hide");
            });
        }
    });
});
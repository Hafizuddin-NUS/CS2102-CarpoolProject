$(() => {
    $('form').submit((event) => {
        event.preventDefault();
        const username = $('#username').val();
        const password = $('#password').val();
        const gender = $('#gender').val();
        const phone_num = $('#phone_num').val();
        const email = $('#email').val();
        const display_name = $('#display_name').val();

        const user = {
            username,
            password,
            gender,
            phone_num,
            email,
            display_name
        }; 

        login(user)
        .then(result => {
            console.log(result);
            window.location = '/select';
        }).catch(error => {
            console.error(error);
            const $errorMessage = $('#errorMessage');
            $errorMessage.text(error.responseJSON.message);
            $errorMessage.show();
        });
    });
});

function login(user) {
    return $.post('http://localhost:3000/auth/signup',user);
}
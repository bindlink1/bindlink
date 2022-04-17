$(document).ready(
    $(function(){


      $("#new_email").validate( {
              rules: {
                   "email[to]": { email: true}

              }
           }

        );
    }));
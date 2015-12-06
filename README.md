# yaml-path-copy package

With this package you can copy a full path of parent yaml key, from selected line.

    pt-BR:
      activerecord:
        errors:
          models:
            user:
              attributes:
                current_password:
                  invalid: "The current password is invalid"  << | cursor in this line >> ctrl-alt-m

    # Will copy the path bellow to your clipboard:
    pt-BR.activerecord.errors.models.user.attributes.current_password

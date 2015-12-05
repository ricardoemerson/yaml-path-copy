# yaml-path-copy package

With this package you can copy a full path of parent yaml key, from selected line.

    pt-BR:
      activerecord:
        errors:
          models:
            user:
              attributes:
                cpf:
                  invalid: "O número do CPF informado é inválido"
                current_password:
                  invalid: "A senha atual informada não é válida"  << | cursor in this line >> ctrl-alt-m

    # Will result in:
    pt-BR.activerecord.errors.models.user.attributes


![A screenshot of your package](https://f.cloud.github.com/assets/69169/2290250/c35d867a-a017-11e3-86be-cd7c5bf3ff9b.gif)

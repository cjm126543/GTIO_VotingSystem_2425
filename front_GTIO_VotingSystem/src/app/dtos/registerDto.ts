export class RegisterDto {
  constructor(
    public nombre: string,
    public apellido: string,
    public nombreUsuario: string,
    public email: string,
    public password: string
  ) {}
}

import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import {
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { LoginDto } from '../../dtos/loginDto';
import { LoginService } from '../../services/loginService';
import { AuthService } from '../../services/authService';
@Component({
  selector: 'app-login',
  imports: [CommonModule, ReactiveFormsModule],
  standalone: true,
  templateUrl: './login.component.html',
  styleUrl: './login.component.css',
})
export class LoginComponent {
  loginForm: FormGroup;
  errorMessage: string | null = null;

  constructor(
    private router: Router,
    private fb: FormBuilder,
    private service: LoginService,
    private authService: AuthService
  ) {
    this.loginForm = this.fb.group({
      nombreUsuario: [''],
      password: [''],
    });
  }

  login() {
    if (this.loginForm.valid) {
      const user: LoginDto = new LoginDto(
        this.loginForm.value.nombreUsuario,
        this.loginForm.value.password
      );

      /*this.service.login(user).subscribe({
        next: (response) => {
          alert('Inicio de sesión exitoso');
          console.log('Respuesta del servidor:', response);
          this.router.navigate(['/demo']);
        },
        error: (err) => {
          this.errorMessage = 'Usuario o contraseña incorrectos';
          console.error('Error:', err);
        },
      });*/
      const fakeToken = 'tu-token-jwt';
      this.authService.login(fakeToken);
      this.router.navigate(['/demo']);
    } else {
      alert('Por favor, ingrese datos válidos');
    }
  }
  goToRegister() {
    this.router.navigate(['/register']);
  }
  //#region Form methods
  get nombreUsuario() {
    return this.loginForm.get('nombreUsuario');
  }

  get password() {
    return this.loginForm.get('password');
  }
  //#endregion
}

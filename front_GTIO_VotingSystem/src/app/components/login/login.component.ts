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
import { AuthMockService } from '../../mocks/authServiceMock';
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
    private service: AuthMockService,
    private authService: AuthService
  ) {
    this.loginForm = this.fb.group({
      nombreUsuario: [''],
      password: [''],
    });
  }

  login() {
    const user: LoginDto = new LoginDto(
      this.loginForm.value.nombreUsuario,
      this.loginForm.value.password
    );

    this.service.login(user).subscribe({
      next: (response) => {
        this.authService.login(response.token);
        this.authService.setVotoRealizado(response.votoRealizado);
        this.router.navigate(['/demo']);
      },
      error: (err) => {
        alert('Usuario o contraseñas incorrectos');
        console.error('Error:', err);
      },
    });
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

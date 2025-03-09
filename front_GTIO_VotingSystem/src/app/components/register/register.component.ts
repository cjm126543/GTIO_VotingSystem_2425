import { Component } from '@angular/core';
import {
  FormBuilder,
  FormGroup,
  Validators,
  ReactiveFormsModule,
  ValidatorFn,
  AbstractControl,
  ValidationErrors,
} from '@angular/forms';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { RegisterDto } from '../../dtos/registerDto';
import { RegisterService } from '../../services/registerService';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './register.component.html',
  styleUrl: './register.component.css',
})
export class RegisterComponent {
  registerForm: FormGroup;
  constructor(
    private router: Router,
    private fb: FormBuilder,
    private service: RegisterService
  ) {
    this.registerForm = this.fb.group(
      {
        email: [
          '',
          [
            Validators.required,
            Validators.pattern(
              /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/
            ),
          ],
        ],
        password: ['', [Validators.required, Validators.minLength(6)]],
        passwordRepeat: ['', [Validators.required]],
        nombre: [
          '',
          [Validators.required, Validators.pattern(/^[a-zA-ZñÑ]+$/)],
        ],
        apellido: [
          '',
          [Validators.required, Validators.pattern(/^[a-zA-ZñÑ]+$/)],
        ],
        nombreUsuario: ['', [Validators.required]],
      },
      { validators: this.passwordMatchValidator() }
    );
  }

  register() {
    if (this.registerForm.valid) {
      const user: RegisterDto = new RegisterDto(
        this.registerForm.value.nombre,
        this.registerForm.value.apellido,
        this.registerForm.value.nombreUsuario,
        this.registerForm.value.email,
        this.registerForm.value.password
      );

      /*this.service.register(user).subscribe({
        next: (response) => {
          alert('Registro exitoso');
          console.log('Respuesta del servidor:', response);
          this.router.navigate(['/demo']);
        },
        error: (err) => {
          alert('Error en el registro');
          console.error('Error:', err);
        },
      });*/

      alert('Registro exitoso');
      console.log(this.registerForm.value);
      this.router.navigate(['/demo']);
    } else {
      alert('Por favor, ingrese datos válidos');
    }
  }

  //#region  Form methods
  get nombre() {
    return this.registerForm.get('nombre');
  }

  get apellido() {
    return this.registerForm.get('apellido');
  }

  get nombreUsuario() {
    return this.registerForm.get('nombreUsuario');
  }

  get email() {
    return this.registerForm.get('email');
  }

  get password() {
    return this.registerForm.get('password');
  }
  get passwordRepeat() {
    return this.registerForm.get('passwordRepeat');
  }
  //#endregion

  passwordMatchValidator(): ValidatorFn {
    return (control: AbstractControl): ValidationErrors | null => {
      const password = control.get('password')?.value;
      const passwordRepeat = control.get('passwordRepeat')?.value;

      // Si los campos coinciden, no hay error
      if (password === passwordRepeat) {
        return null;
      }

      // Si no coinciden, devuelve un error
      return { passwordMismatch: true };
    };
  }
}

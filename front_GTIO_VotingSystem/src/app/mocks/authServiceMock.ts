import { Injectable } from '@angular/core';
import { BehaviorSubject, of, throwError } from 'rxjs';
import { delay } from 'rxjs/operators';
import { LoginDto } from '../dtos/loginDto';

@Injectable({
  providedIn: 'root',
})
export class AuthMockService {
  login(login: LoginDto) {
    if (login.email === 'user@example.com' && login.password === 'password') {
      return of({ token: 'fake-jwt-token', votoRealizado: false }).pipe(
        delay(1000)
      );
    } else {
      return throwError('Usuario o contraseña incorrectos').pipe(delay(1000));
    }
  }

  register(user: any) {
    return of({ message: 'Registro exitoso', token: 'fake-jwt-token' }).pipe(
      delay(1000)
    );
    //return throwError('Usuario o contraseña incorrectos').pipe(delay(1000))
  }
}

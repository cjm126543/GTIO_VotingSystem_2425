import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { BehaviorSubject } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private isLoggedInSubject = new BehaviorSubject<boolean>(this.hasToken());
  isLoggedIn$ = this.isLoggedInSubject.asObservable();
  private votoRealizadoSubject = new BehaviorSubject<boolean>(this.hasVoted());
  votoRealizado$ = this.votoRealizadoSubject.asObservable();

  constructor(private router: Router) {}

  // Verifica si hay un token en el localStorage
  private hasToken(): boolean {
    return !!localStorage.getItem('authToken');
  }
  private hasVoted(): boolean {
    return !!localStorage.getItem('votoRealizado');
  }

  login(token: string): void {
    localStorage.setItem('authToken', token);
    this.isLoggedInSubject.next(true);
    this.router.navigate(['/']);
  }

  logout(): void {
    localStorage.removeItem('authToken');
    this.isLoggedInSubject.next(false);
    localStorage.removeItem('votoRealizado');
    this.votoRealizadoSubject.next(false);
    this.router.navigate(['/login']);
  }
  votar(id: any): void {
    localStorage.setItem('votoRealizado', id);
    this.votoRealizadoSubject.next(true);
  }

  getToken(): string | null {
    return localStorage.getItem('authToken');
  }
  isLoggedIn(): boolean {
    return this.isLoggedInSubject.value;
  }
  isVoted(): boolean {
    return this.votoRealizadoSubject.value;
  }
  setVotoRealizado(realizado: boolean) {
    if (realizado) {
      localStorage.setItem('votoRealizado', '');
      this.votoRealizadoSubject.next(true);
    }
  }
}

import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { LoginDto } from '../dtos/loginDto';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class LoginService {
  private apiUrl = '';

  constructor(private http: HttpClient) {}

  login(user: LoginDto): Observable<any> {
    return this.http.post(this.apiUrl, user);
  }
}

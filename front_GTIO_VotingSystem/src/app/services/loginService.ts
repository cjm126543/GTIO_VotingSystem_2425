import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { LoginDto } from '../dtos/loginDto';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root',
})
export class LoginService {
  private apiUrl = environment.apiUrl + '/api/users/login';

  constructor(private http: HttpClient) {}

  login(user: LoginDto): Observable<any> {
    return this.http.post(this.apiUrl, user);
  }
}

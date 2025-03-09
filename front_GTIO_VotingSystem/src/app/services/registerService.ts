import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { RegisterDto } from '../dtos/registerDto';

@Injectable({
  providedIn: 'root',
})
export class RegisterService {
  private apiUrl = '';

  constructor(private http: HttpClient) {}

  register(user: RegisterDto): Observable<any> {
    return this.http.post(this.apiUrl, user);
  }
}

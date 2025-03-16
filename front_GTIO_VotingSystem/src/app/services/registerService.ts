import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { RegisterDto } from '../dtos/registerDto';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root',
})
export class RegisterService {
  private apiUrl = environment.apiUrl + '/api/users/register';

  constructor(private http: HttpClient) {}

  register(user: RegisterDto): Observable<any> {
    console.log(user);
    return this.http.post(this.apiUrl, user);
  }
}

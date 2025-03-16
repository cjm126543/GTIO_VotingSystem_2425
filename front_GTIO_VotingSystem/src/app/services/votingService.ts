import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { RegisterDto } from '../dtos/registerDto';
import { VoteDto } from '../dtos/voteDto';
import { environment } from '../../environments/environment';
import { AuthService } from './authService';

@Injectable({
  providedIn: 'root',
})
export class VotingService {
  private apiUrl = environment.apiUrl + '/api/votos';

  constructor(private http: HttpClient, private authService: AuthService) {}

  votar(voto: VoteDto): Observable<any> {
    const token = this.authService.getToken();
    const headers = new HttpHeaders({
      Authorization: `Bearer ${token}`,
    });
    return this.http.post(this.apiUrl + '/registrarVoto', voto, { headers });
  }
  getVotos(): Observable<any> {
    return this.http.get(this.apiUrl);
  }
  getParticipantes(): Observable<any> {
    return this.http.get(environment.apiUrl + '/api/artistas');
  }
}

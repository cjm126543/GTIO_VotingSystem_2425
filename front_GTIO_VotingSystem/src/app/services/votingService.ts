import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { RegisterDto } from '../dtos/registerDto';
import { VoteDto } from '../dtos/voteDto';

@Injectable({
  providedIn: 'root',
})
export class VotingService {
  private apiUrl = '';

  constructor(private http: HttpClient) {}

  votar(voto: VoteDto): Observable<any> {
    return this.http.post(this.apiUrl, voto);
  }
}

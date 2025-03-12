import { Injectable } from '@angular/core';
import { of } from 'rxjs';
import { delay } from 'rxjs/operators';
import { VoteDto } from '../dtos/voteDto';

@Injectable({
  providedIn: 'root',
})
export class VotingMockService {
  private votos: any = { opcion1: 0, opcion2: 0 };

  votar(voto: VoteDto) {
    this.votos[voto.nombreParticipante]++;
    return of({ votos: this.votos }).pipe(delay(500));
  }

  obtenerVotos() {
    return of({ votos: this.votos }).pipe(delay(500));
  }
}

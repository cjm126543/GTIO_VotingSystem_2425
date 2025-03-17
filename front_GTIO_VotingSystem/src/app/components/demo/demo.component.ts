import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AuthService } from '../../services/authService';
import { AuthMockService } from '../../mocks/authServiceMock';
import { VotingMockService } from '../../mocks/votingServiceMock';
import { VoteDto } from '../../dtos/voteDto';
import { environment } from '../../../environments/environment';
import { VotingService } from '../../services/votingService';
import { NotExpr } from '@angular/compiler';

@Component({
  selector: 'app-demo',
  imports: [CommonModule],
  templateUrl: './demo.component.html',
  styleUrl: './demo.component.css',
})
export class DemoComponent {
  participantes = [
    // {
    //   id: 'opcion1',
    //   nombre: 'Naiara',
    //   img: 'https://www.formulatv.com/images/fgaleria/85600/85667_cv03.jpg',
    // },
    // {
    //   id: 'opcion2',
    //   nombre: 'Lucas',
    //   img: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxryLaY3O24KCCrYp8xiLKTxju6j9miEh8Vg&s',
    // },
    {
      idArtista: 1,
      nombre: 'Lucas',
      apellidos: 'a',
      biografia: 'Mató a una mosca',
      sexo: 'Masculino',
      linkFoto: 'www.google.es',
    },
  ];

  votos: any = { opcion1: 0, opcion2: 0 };
  votoRealizado: boolean = false;

  constructor(
    private authService: AuthService,
    private service: AuthMockService,
    private votingServiceMock: VotingMockService,
    private votingService: VotingService
  ) {
    this.authService.votoRealizado$.subscribe((votoRealizado) => {
      this.votoRealizado = votoRealizado;
      console.log('constructir: ', votoRealizado);
    });
  }

  ngOnInit() {
    this.votingService.getParticipantes().subscribe({
      next: (response) => {
        this.participantes = response;
        console.log(this.participantes);
      },
      error: (err) => {
        console.error('Error al obtener los participantes:', err);
      },
    });
    this.votingService.getVotos().subscribe({
      next: (response) => {
        this.votos = response;
        console.log('getVotos', response);
      },
      error: (err) => {
        console.error('Error al obtener los votos:', err);
      },
    });

    /*this.votos = JSON.parse(
      localStorage.getItem('votos') || '{"opcion1":0,"opcion2":0}'
    );
    this.votoRealizado = localStorage.getItem('votoRealizado');*/
  }

  votar(id: number) {
    const voto: VoteDto = {
      idArtista: id,
    };
    this.votingService.votar(voto).subscribe({
      next: (response) => {
        console.log(response);
        //this.votos = response.votos;
        //this.authService.votar(id);
      },
      error: (err) => {
        alert('Error al contabilizar el voto');
        console.error('Error al votar:', err);
      },
    });
    /*if (!this.authService.isLoggedIn()) {
      alert('Debes iniciar sesión para votar.');
      return;
    }

    this.votoRealizado = id;
    localStorage.setItem('votoRealizado', id);
    this.votos[id]++;
    localStorage.setItem('votos', JSON.stringify(this.votos));*/
  }
  totalVotos(): number {
    return this.votos['opcion1'] + this.votos['opcion2'];
  }
  isLoggedIn(): boolean {
    return this.authService.isLoggedIn();
  }
}

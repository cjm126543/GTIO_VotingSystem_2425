import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AuthService } from '../../services/authService';
import { AuthMockService } from '../../mocks/authServiceMock';
import { VotingMockService } from '../../mocks/votingServiceMock';
import { VoteDto } from '../../dtos/voteDto';

@Component({
  selector: 'app-demo',
  imports: [CommonModule],
  templateUrl: './demo.component.html',
  styleUrl: './demo.component.css',
})
export class DemoComponent {
  participantes = [
    {
      id: 'opcion1',
      nombre: 'Naiara',
      img: 'https://www.formulatv.com/images/fgaleria/85600/85667_cv03.jpg',
    },
    {
      id: 'opcion2',
      nombre: 'Lucas',
      img: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxryLaY3O24KCCrYp8xiLKTxju6j9miEh8Vg&s',
    },
  ];

  votos: any = { opcion1: 0, opcion2: 0 };
  votoRealizado: boolean = false;

  constructor(
    private authService: AuthService,
    private service: AuthMockService,
    private votingService: VotingMockService
  ) {
    this.authService.votoRealizado$.subscribe((votoRealizado) => {
      this.votoRealizado = votoRealizado;
      console.log('constructir: ', votoRealizado);
    });
  }

  ngOnInit() {
    this.votingService.obtenerVotos().subscribe({
      next: (response) => {
        this.votos = response.votos;
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

  votar(nombre: string) {
    const voto: VoteDto = new VoteDto('usuario', nombre);
    this.votingService.votar(voto).subscribe({
      next: (response) => {
        this.votos = response.votos;
        this.authService.votar(nombre);
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

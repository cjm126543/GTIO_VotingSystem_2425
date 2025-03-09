import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

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
  votoRealizado: string | null = null;

  ngOnInit() {
    //this.votoRealizado = localStorage.getItem('votoRealizado');
    this.votos = JSON.parse(
      localStorage.getItem('votos') || '{"opcion1":0,"opcion2":0}'
    );
  }

  votar(id: string) {
    this.votoRealizado = id;
    localStorage.setItem('votoRealizado', id);
    this.votos[id]++;
    localStorage.setItem('votos', JSON.stringify(this.votos));
  }
}

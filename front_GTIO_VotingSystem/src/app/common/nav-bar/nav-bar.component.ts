import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-nav-bar',
  imports: [CommonModule],
  templateUrl: './nav-bar.component.html',
  styleUrl: './nav-bar.component.css',
})
export class NavBarComponent {
  isLoggedIn: boolean;

  constructor(private router: Router) {
    this.isLoggedIn = !!localStorage.getItem('loggedIn');
    console.log(this.isLoggedIn);
  }

  logout() {
    localStorage.removeItem('loggedIn');
    this.isLoggedIn = false;
    this.router.navigate(['/login']);
  }
  onLogin() {
    localStorage.setItem('loggedIn', 'true');
    this.isLoggedIn = true;
    this.router.navigate(['/login']);
  }
}

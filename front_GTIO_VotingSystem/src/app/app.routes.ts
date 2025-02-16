import { Routes } from '@angular/router';
import { LoginComponent } from './components/login/login.component';
import { DemoComponent } from './components/demo/demo.component';

export const routes: Routes = [
  { path: 'login', component: LoginComponent },
  { path: 'demo', component: DemoComponent },
];

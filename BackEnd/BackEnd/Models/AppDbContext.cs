using Microsoft.EntityFrameworkCore;

namespace BackEnd.Models
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }

        public DbSet<dtUsuarios> dtUsuarios { get; set; }
        public DbSet<dtArtistas> dtArtistas { get; set; }
        public DbSet<dtVotos> dtVotos { get; set; }
        public DbSet<msRolesUsuario> msRolesUsuario { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Relación Usuario - Rol
            modelBuilder.Entity<dtUsuarios>()
                .HasOne(u => u.IDRolUsuarioNavigation)
                .WithMany(r => r.Usuarios)
                .HasForeignKey(u => u.IDRolUsuario)
                .OnDelete(DeleteBehavior.Cascade);

            // Relación Votos - Usuario
            modelBuilder.Entity<dtVotos>()
                .HasOne(v => v.IDUsuarioNavigation)
                .WithMany()
                .HasForeignKey(v => v.IDUsuario);

            // Relación Votos - Artista
            modelBuilder.Entity<dtVotos>()
                .HasOne(v => v.IDArtistaNavigation)
                .WithMany()
                .HasForeignKey(v => v.IDArtista);
        }
    }
}


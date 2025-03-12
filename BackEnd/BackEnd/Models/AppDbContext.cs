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
        public DbSet<msRolesUsuario> msRolesUsuario { get; set; } // Ensure roles are in the DbContext

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<dtUsuarios>()
                .HasOne(u => u.IDRolUsuarioNavigation)
                .WithMany(r => r.Usuarios)
                .HasForeignKey(u => u.IDRolUsuario)
                .OnDelete(DeleteBehavior.Cascade);

        }
    }
}


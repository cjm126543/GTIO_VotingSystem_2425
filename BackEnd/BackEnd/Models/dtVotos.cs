using System;
using System.ComponentModel.DataAnnotations;

namespace BackEnd.Models
{
    public class dtVotos
    {
        [Key]
        public int Id { get; set; }

        public required dtArtistas IDArtista { get; set; }

        public required dtUsuarios IDUsuario { get; set; }

        public required DateTime FechaVoto { get; set; } = DateTime.UtcNow;

        public bool Eliminado { get; set; } = false;



    }
}

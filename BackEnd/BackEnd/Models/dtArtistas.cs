using System;
using System.ComponentModel.DataAnnotations;

namespace BackEnd.Models
{
    public class dtArtistas
    {
        [Key]
        public int IDArtista { get; set; }

        public required string Nombre { get; set; } 

        public required string Apellidos { get; set; }

        public required string Sexo { get; set; }

        public required string LinkFoto { get; set; }      

        public required string Biografia { get; set; }

        public bool Eliminado { get; set; } = false;
    }
}

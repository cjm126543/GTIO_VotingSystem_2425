using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BackEnd.Models
{
    public class dtVotos
    {
        [Key]
        public int IDVoto { get; set; }

        public int IDUsuario { get; set; }

        [ForeignKey("IDUsuario")]
        public dtUsuarios? IDUsuarioNavigation { get; set; }

        public int IDArtista { get; set; }

        [ForeignKey("IDArtista")]
        public dtArtistas? IDArtistaNavigation { get; set; }

        public DateTime FechaVoto { get; set; } = DateTime.UtcNow;

        public bool Eliminado { get; set; } = false;
    }
}


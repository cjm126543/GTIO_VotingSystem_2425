using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BackEnd.Models
{
    public class dtUsuarios
    {
        [Key]
        public int IDUsuario { get; set; }

        public string? Nombre { get; set; }

        public string? Apellidos { get; set; }

        [EmailAddress]
        public required string Correo { get; set; }

        public required string Contrasenia { get; set; } 

        public bool Eliminado { get; set; } = false;

        public int? IDRolUsuario { get; set; }

        public virtual msRolesUsuario? IDRolUsuarioNavigation { get; set; }
    }
}

using System;
using System.ComponentModel.DataAnnotations;

namespace BackEnd.Models
{
    public class msRolesUsuario
    {
        [Key]
        public int IDRolUsuario { get; set; }

        public required string DescripcionRol { get; set; }

        public bool Eliminado { get; set; } = false;

        public virtual ICollection<dtUsuarios>? Usuarios { get; set; }

    }
}

using System.Security.Claims;
using BackEnd.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

[Route("api/votos")]
[ApiController]
public class VoteController : ControllerBase
{
    private readonly AppDbContext _context;

    public VoteController(AppDbContext context)
    {
        _context = context;
    }

    [Authorize]
    [HttpPost("registrarVoto")]
    public async Task<IActionResult> RegistrarVoto([FromBody] VotoRequest votoRequest)
    {
        var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (userEmail == null)
            return Unauthorized("No autorizado");

        var usuario = await _context.dtUsuarios
            .FirstOrDefaultAsync(u => u.Correo == userEmail && !u.Eliminado);

        if (usuario == null)
            return Unauthorized("Usuario no encontrado");

        var artista = await _context.dtArtistas
            .FirstOrDefaultAsync(a => a.IDArtista == votoRequest.IDArtista && !a.Eliminado);

        if (artista == null)
            return NotFound("Artista no encontrado");

        var hoy = DateTime.UtcNow.Date;
        var votoHoy = await _context.dtVotos
            .AnyAsync(v => v.IDUsuario == usuario.IDUsuario &&
                           v.FechaVoto.Date == hoy &&
                           !v.Eliminado);

        if (votoHoy)
            return BadRequest("Ya has votado hoy. Solo puedes votar una vez al día.");

        var voto = new dtVotos
        {
            IDUsuario = usuario.IDUsuario,
            IDArtista = artista.IDArtista,
            FechaVoto = DateTime.UtcNow,
            Eliminado = false
        };

        _context.dtVotos.Add(voto);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Voto registrado con éxito" });
    }

    [HttpGet]
    public async Task<IActionResult> ObtenerTodosLosVotos()
    {
        var votos = await _context.dtVotos
            .Include(v => v.IDUsuarioNavigation)
            .Include(v => v.IDArtistaNavigation)
            .Where(v => !v.Eliminado)
            .Select(v => new
            {
                v.IDVoto,
                Usuario = $"{v.IDUsuarioNavigation.Nombre} {v.IDUsuarioNavigation.Apellidos}",
                Artista = $"{v.IDArtistaNavigation.Nombre} {v.IDArtistaNavigation.Apellidos}",
                FechaVoto = v.FechaVoto
            })
            .ToListAsync();

        return Ok(votos);
    }

    [Authorize]
    [HttpGet("usuario/{idUsuario}")]
    public async Task<IActionResult> ObtenerVotosPorUsuario(int idUsuario)
    {
        var votos = await _context.dtVotos
            .Include(v => v.IDArtistaNavigation)
            .Where(v => v.IDUsuario == idUsuario && !v.Eliminado)
            .Select(v => new
            {
                v.IDVoto,
                Artista = $"{v.IDArtistaNavigation.Nombre} {v.IDArtistaNavigation.Apellidos}",
                FechaVoto = v.FechaVoto
            })
            .ToListAsync();

        return Ok(votos);
    }

    [Authorize(Roles = "Administrador")]
    [HttpDelete("eliminar/{id}")]
    public async Task<IActionResult> EliminarVoto(int id)
    {
        var voto = await _context.dtVotos
            .FirstOrDefaultAsync(v => v.IDVoto == id && !v.Eliminado);

        if (voto == null)
            return NotFound("Voto no encontrado");

        voto.Eliminado = true;
        await _context.SaveChangesAsync();

        return Ok(new { message = "Voto eliminado correctamente" });
    }

    [AllowAnonymous]
    [HttpGet("resultados")]
    public async Task<IActionResult> ObtenerResultadosVotaciones()
    {
        var resultados = await _context.dtVotos
            .Where(v => !v.Eliminado)
            .Include(v => v.IDArtistaNavigation) 
            .GroupBy(v => new
            {
                v.IDArtista,
                v.IDArtistaNavigation.Nombre,
                v.IDArtistaNavigation.Apellidos
            })
            .Select(group => new
            {
                IDArtista = group.Key.IDArtista,
                NombreArtista = group.Key.Nombre + " " + group.Key.Apellidos,
                TotalVotos = group.Count()
            })
            .OrderByDescending(r => r.TotalVotos)
            .ToListAsync();

        return Ok(resultados);
    }

    public class VotoRequest
    {
        public int IDArtista { get; set; }
    }
}

using BackEnd.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

[Route("api/artistas")]
[ApiController]
public class ArtistController : ControllerBase
{
    private readonly AppDbContext _context;

    public ArtistController(AppDbContext context)
    {
        _context = context;
    }

    // ✅ GET: api/artistas
    [AllowAnonymous] // Si es para poblar el frontend sin requerir autorización
    [HttpGet]
    public async Task<IActionResult> ObtenerTodosLosArtistas()
    {
        var artistas = await _context.dtArtistas
            .Where(a => !a.Eliminado)
            .Select(a => new
            {
                a.IDArtista,
                a.Nombre,
                a.Apellidos,
                a.Sexo,
                a.LinkFoto,
                a.Biografia
            })
            .ToListAsync();

        return Ok(artistas);
    }
}

FROM mssqlserver

ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=<contrasena>
ENV MSSQL_PID=Developer
ENV WORKDIR /tmp/mssql/db_scripts

RUN mkdir -p ${WORKDIR}

COPY AltaTablasYMaestros.sql ${WORKDIR}
COPY BorrarTablas.sql ${WORKDIR}

EXPOSE 1433

CMD /opt/mssql/bin/sqlservr


FROM openscad/openscad:dev

ENV DEBIAN_FRONTEND=noninteractive

# Install Python & FastAPI inside the OpenSCAD dev image
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install BOSL2 into OpenSCAD's global library path
RUN mkdir -p /usr/share/openscad/libraries && \
    git clone --depth 1 https://github.com/BelfrySCAD/BOSL2.git /usr/share/openscad/libraries/BOSL2

RUN pip3 install --no-cache-dir --break-system-packages fastapi uvicorn pydantic

WORKDIR /app
COPY ./app /app

EXPOSE 8095

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8095"]

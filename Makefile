SHELL = /bin/sh

PREFIX ?= $(shell pwd)
BINDIR ?= $(PREFIX)/bin

TARGET ?= $(BINDIR)/ql
SOURCE = ql.swift

SWIFTC ?= swiftc
SWIFTCFLAGS ?= -O

RM ?= rm

all: $(TARGET)

$(BINDIR):
	mkdir -p $(BINDIR)

$(TARGET): $(BINDIR) $(SOURCE)
	$(SWIFTC) $(SWIFTCFLAGS) -o $(TARGET) $(SOURCE)

clean:
	@$(RM) -i $(TARGET)

# Meetings pack: rules

Adds meeting notes, transcript processing, and the habit of pushing action items onto the owning project.

## Where meetings live

A meeting belongs where its subject lives: `01_Projects/<Project>/Meetings/` or `02_Areas/<Area>/Meetings/`, created with the first meeting. A meeting that maps to nothing yet stays in `00_Inbox/` until it does. Name meeting notes `YYYY-MM-DD Topic.md`.

## Transcripts

- **The raw transcript is a source, and sources are immutable.** It goes to `05_Attachments/Transcripts/YYYY/`, verbatim. The meeting note sits above it and links down to it.
- **Write a known-errors header at the top of the normalized transcript** (never the raw file) before building anything on it. Transcription services mangle proper nouns fluently and confidently, and occasionally turn a phrase into its opposite. List each suspected error and what the speaker probably meant.
- **A transcription service's own AI summary is not a source.** It can repeat a misheard quote verbatim and draw conclusions from it. Read the transcript.
- **Confirm any load-bearing quote** with the person before relying on it.
- **Recording consent is the owner's call.** Never suggest recording a conversation where recording isn't allowed or wasn't agreed.

## Intent routing (added)

| The person says | Skill |
| --- | --- |
| "write up this meeting", "here are my notes from the call" | `process-meeting` |
| "process this transcript", drops a transcript file | `process-transcript` |
